// NOTE: replace your existing file contents with this file.
import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:intl/intl.dart';
import 'package:kacamatamoo/core/constants/assets_constants.dart';

class GlassesModel {
  final String id;
  final String assetImage;
  final double baseEyeDist;
  // Per-model tuning (pixels or normalized scale)
  final Offset anchorOffset; // x,y in pixels (applied after mapping)
  final double rotationOffsetDeg; // fine tune rotation
  final double scaleMultiplier; // multiply computed scale

  GlassesModel({
    required this.id,
    required this.assetImage,
    this.baseEyeDist = 60,
    this.anchorOffset = Offset.zero,
    this.rotationOffsetDeg = 0.0,
    this.scaleMultiplier = 1.0,
  });
}

/// Output transform for overlay
class TransformData {
  final Offset center; // center in screen coords (px)
  final double rotation; // radians
  final double scale; // multiplier

  TransformData({
    required this.center,
    required this.rotation,
    required this.scale,
  });
}

class VirtualTryOnV2Controller extends GetxController {
  static final _fixedLocaleNumberFormatter = NumberFormat.decimalPatternDigits(
    locale: 'en_gb',
    decimalDigits: 2,
  );

  CameraController? cameraController;
  List<CameraDescription>? cameras;

  final Rxn<Face> currentFace = Rxn<Face>();
  // kept for compatibility; we compute rotation per-frame in _inputImageFromCameraImage
  final RxBool isProcessing = false.obs;

  // Unity AR properties
  bool? _isUnityArSupportedOnDevice;
  bool _isArSceneActive = false;
  double _rotationSpeed = 30;
  int _numberOfTaps = 0;

  // Getters
  bool? get isUnityArSupportedOnDevice => _isUnityArSupportedOnDevice;
  bool get isArSceneActive => _isArSceneActive;
  double get rotationSpeed => _rotationSpeed;
  int get numberOfTaps => _numberOfTaps;

  String get arStatusMessage {
    if (_isUnityArSupportedOnDevice == null) {
      return "checking...";
    } else if (_isUnityArSupportedOnDevice!) {
      return "supported";
    } else {
      return "not supported on this device";
    }
  }

  final faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      performanceMode: FaceDetectorMode.fast,
      enableContours:
          false, // enableContours:true if you later want eye corners
      enableLandmarks: true,
      enableClassification: false,
    ),
  );

  // Glasses data - add tuning per model as needed
  final RxList<GlassesModel> glasses = <GlassesModel>[
    GlassesModel(
      id: 'g1',
      assetImage: AssetsConstants.aviatorThumb,
      baseEyeDist: 60,
      anchorOffset: const Offset(0, -6), // upward tweak in px
      rotationOffsetDeg: 2.0,
      scaleMultiplier: 1.02,
    ),
    GlassesModel(
      id: 'g2',
      assetImage: AssetsConstants.wayfarerThumb,
      baseEyeDist: 60,
    ),
    GlassesModel(
      id: 'g3',
      assetImage: AssetsConstants.roundThumb,
      baseEyeDist: 60,
    ),
  ].obs;

  final Rxn<GlassesModel> selectedGlasses = Rxn<GlassesModel>();

  // smoothing state
  Offset? _prevCenter;
  double? _prevRotation;
  double? _prevScale;

  // smoothing factor (0..1). Higher = snappier. Try 0.35-0.6.
  final double smoothingAlpha = 0.45;

  // preview mirroring flag (set true if CameraPreview is mirrored)
  bool previewMirrored = false;

  // Device orientation -> degrees map
  static const Map<DeviceOrientation, int> _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  @override
  void onInit() {
    super.onInit();
    // choose default
    selectedGlasses.value = glasses.isNotEmpty ? glasses.first : null;
    _initCameras();
  }

  Future<void> _initCameras() async {
    try {
      cameras = await availableCameras();
      final front = cameras!.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras!.first,
      );

      cameraController = CameraController(
        front,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await cameraController!.initialize();
      await cameraController!.startImageStream(_processCameraImage);
      update();
    } catch (e, st) {
      debugPrint('Camera init error: $e\n$st');
    }
  }

  void _processCameraImage(CameraImage image) async {
    if (isProcessing.value) return;
    isProcessing.value = true;

    try {
      final inputImage = _inputImageFromCameraImage(image);
      if (inputImage == null) {
        isProcessing.value = false;
        return;
      }

      final faces = await faceDetector.processImage(inputImage);

      if (faces.isNotEmpty) {
        currentFace.value = faces.first;
      } else {
        currentFace.value = null;
      }
    } catch (e) {
      debugPrint('Face detect error: $e');
    } finally {
      isProcessing.value = false;
    }
  }

  /// Build an [InputImage] from [CameraImage] using rotation/format compensation.
  ///
  /// This version avoids older helper types and instead:
  /// - computes rotation compensation (based on sensor + device orientation)
  /// - converts YUV_420_888 (multi-plane) -> NV21 for Android (single byte buffer)
  /// - uses BGRA single-plane on iOS when available
  /// - constructs InputImage.fromBytes with InputImageMetadata (current ML Kit API)
  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (cameraController == null || cameraController!.description == null)
      return null;

    final camera = cameraController!.description;
    final sensorOrientation = camera.sensorOrientation;

    // compute rotation compensation
    int? rotationCompensation;
    if (Platform.isIOS) {
      rotationCompensation = sensorOrientation;
    } else if (Platform.isAndroid) {
      final devOrient = cameraController!.value.deviceOrientation;
      final orientationDeg = _orientations[devOrient];
      if (orientationDeg == null) {
        debugPrint('Device orientation degrees not found for $devOrient');
        return null;
      }

      if (camera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + orientationDeg) % 360;
      } else {
        // back-facing
        rotationCompensation = (sensorOrientation - orientationDeg + 360) % 360;
      }
    } else {
      // fallback to sensor orientation
      rotationCompensation = sensorOrientation;
    }

    final rotationValue = InputImageRotationValue.fromRawValue(
      rotationCompensation,
    );
    if (rotationValue == null) {
      debugPrint(
        'Unable to create InputImageRotationValue from $rotationCompensation',
      );
      return null;
    }

    try {
      if (Platform.isAndroid) {
        // Convert to NV21 byte array (most Android ML Kit expects NV21).
        final nv21 = _convertYUV420ToNV21(image);
        return InputImage.fromBytes(
          bytes: nv21,
          metadata: InputImageMetadata(
            size: Size(image.width.toDouble(), image.height.toDouble()),
            rotation: rotationValue,
            format: InputImageFormat.nv21, // explicit NV21 format
            bytesPerRow: image.planes[0].bytesPerRow,
          ),
        );
      } else if (Platform.isIOS) {
        // iOS often provides single-plane BGRA8888; use that directly when available.
        if (image.planes.length == 1) {
          final plane = image.planes.first;
          return InputImage.fromBytes(
            bytes: plane.bytes,
            metadata: InputImageMetadata(
              size: Size(image.width.toDouble(), image.height.toDouble()),
              rotation: rotationValue,
              format: InputImageFormat.bgra8888,
              bytesPerRow: plane.bytesPerRow,
            ),
          );
        } else {
          // If multi-plane on iOS (rare), fall back to concatenation + NV21-like handling
          final all = WriteBuffer();
          for (final p in image.planes) all.putUint8List(p.bytes);
          final bytes = all.done().buffer.asUint8List();
          return InputImage.fromBytes(
            bytes: bytes,
            metadata: InputImageMetadata(
              size: Size(image.width.toDouble(), image.height.toDouble()),
              rotation: rotationValue,
              format: InputImageFormat.nv21,
              bytesPerRow: image.planes[0].bytesPerRow,
            ),
          );
        }
      } else {
        // Other platforms: try concatenation
        final all = WriteBuffer();
        for (final p in image.planes) all.putUint8List(p.bytes);
        final bytes = all.done().buffer.asUint8List();
        return InputImage.fromBytes(
          bytes: bytes,
          metadata: InputImageMetadata(
            size: Size(image.width.toDouble(), image.height.toDouble()),
            rotation: rotationValue,
            format: InputImageFormat.nv21,
            bytesPerRow: image.planes[0].bytesPerRow,
          ),
        );
      }
    } catch (e) {
      debugPrint('Failed to create InputImage: $e');
      return null;
    }
  }

  /// Convert YUV_420_888 (CameraImage.planes) to NV21 byte array expected by ML Kit on Android.
  /// This function assembles Y plane followed by interleaved VU (NV21).
  Uint8List _convertYUV420ToNV21(CameraImage image) {
    final int width = image.width;
    final int height = image.height;

    final Plane yPlane = image.planes[0];
    final Plane uPlane = image.planes[1];
    final Plane vPlane = image.planes[2];

    final int yRowStride = yPlane.bytesPerRow;
    final int uvRowStride = uPlane.bytesPerRow;
    final int uvPixelStride = uPlane.bytesPerPixel ?? 1;

    final int nv21Length =
        width * height + 2 * ((width / 2).floor() * (height / 2).floor());
    final Uint8List nv21 = Uint8List(nv21Length);
    int index = 0;

    // copy Y plane
    for (int row = 0; row < height; row++) {
      final int rowStart = row * yRowStride;
      nv21.setRange(index, index + width, yPlane.bytes, rowStart);
      index += width;
    }

    // interleave V (from plane 2) and U (from plane 1) => VU VU VU ...
    final int chromaHeight = (height / 2).floor();
    final int chromaWidth = (width / 2).floor();

    for (int row = 0; row < chromaHeight; row++) {
      final int rowStart = row * uvRowStride;
      for (int col = 0; col < chromaWidth; col++) {
        final int uvIndex = rowStart + col * uvPixelStride;
        // Ensure indexes are valid
        final int v = vPlane.bytes[uvIndex];
        final int u = uPlane.bytes[uvIndex];
        nv21[index++] = v;
        nv21[index++] = u;
      }
    }

    return nv21;
  }

  /// Convert ML Kit point (image-space) into widget/screen coordinates.
  /// widgetSize must be the exact size of the widget that displays the camera preview.
  Offset cameraImageToScreen(Offset imagePoint, Size widgetSize) {
    final camCtrl = cameraController;
    if (camCtrl == null ||
        !camCtrl.value.isInitialized ||
        camCtrl.value.previewSize == null) {
      return Offset.zero;
    }

    final previewSize = camCtrl.value.previewSize!;
    final sensorOrientation = camCtrl.description.sensorOrientation;
    final isFront =
        camCtrl.description.lensDirection == CameraLensDirection.front;

    double imageWidth = previewSize.width;
    double imageHeight = previewSize.height;

    // Swap coordinates if sensor rotates the preview
    bool swapWH = (sensorOrientation == 90 || sensorOrientation == 270);
    double imgX = imagePoint.dx;
    double imgY = imagePoint.dy;
    if (swapWH) {
      final tmpX = imgX;
      imgX = imgY;
      imgY = tmpX;
      final tmp = imageWidth;
      imageWidth = imageHeight;
      imageHeight = tmp;
    }

    // scale to fit (cover)
    final scale = math.max(
      widgetSize.width / imageWidth,
      widgetSize.height / imageHeight,
    );
    final fittedWidth = imageWidth * scale;
    final fittedHeight = imageHeight * scale;

    final dx = (widgetSize.width - fittedWidth) / 2.0;
    final dy = (widgetSize.height - fittedHeight) / 2.0;

    final shouldMirror = previewMirrored && isFront;

    final screenX =
        dx + (shouldMirror ? (imageWidth - imgX) * scale : imgX * scale);
    final screenY = dy + imgY * scale;

    return Offset(screenX, screenY);
  }

  /// Compute center/scale/rotation in screen coords (requires previewSize).
  /// Applies smoothing if enabled.
  // Replace your existing computeTransformFromFace with this improved version
  TransformData computeTransformFromFace(
    Face face,
    Size previewWidgetSize, {
    GlassesModel? model,
  }) {
    // landmarks (use landmarks if available)
    final leftEyeLm = face.landmarks[FaceLandmarkType.leftEye]?.position;
    final rightEyeLm = face.landmarks[FaceLandmarkType.rightEye]?.position;
    final noseLm = face.landmarks[FaceLandmarkType.noseBase]?.position;

    // fallback: use bounding box center if landmarks absent
    final bbox = face.boundingBox;
    final fallbackCenterImage = Offset(bbox.center.dx, bbox.center.dy);

    final imageLeft = leftEyeLm != null
        ? Offset(leftEyeLm.x.toDouble(), leftEyeLm.y.toDouble())
        : fallbackCenterImage;
    final imageRight = rightEyeLm != null
        ? Offset(rightEyeLm.x.toDouble(), rightEyeLm.y.toDouble())
        : fallbackCenterImage;
    final imageNose = noseLm != null
        ? Offset(noseLm.x.toDouble(), noseLm.y.toDouble())
        : fallbackCenterImage;

    // Map to screen coordinates using your cameraImageToScreen helper
    final leftScreen = cameraImageToScreen(imageLeft, previewWidgetSize);
    final rightScreen = cameraImageToScreen(imageRight, previewWidgetSize);
    final noseScreen = cameraImageToScreen(imageNose, previewWidgetSize);

    // center between eyes
    final eyeCenter = Offset(
      (leftScreen.dx + rightScreen.dx) / 2.0,
      (leftScreen.dy + rightScreen.dy) / 2.0,
    );

    // Better center: blend eye center and nose Y to place bridge correctly
    // weightNose (0..1) controls how much nose pulls the vertical position; 0.3..0.4 is a good start
    final double weightNose = 0.35;
    final Offset blendedCenter = Offset(
      eyeCenter.dx,
      eyeCenter.dy * (1.0 - weightNose) + noseScreen.dy * weightNose,
    );

    // Compute screen eye distance (pixels) and scale relative to model baseEyeDist
    final double eyeDistScreen = (leftScreen - rightScreen).distance;
    final double base = model?.baseEyeDist ?? 60.0;
    double scale = eyeDistScreen / base;
    if (model != null) scale *= model.scaleMultiplier;

    // Rotation: prefer roll (headEulerAngleZ) for 2D tilt of glasses
    // Use roll degrees if available; fall back to vector angle between eyes if not.
    final double rollDeg = face.headEulerAngleZ ?? double.nan;
    double rotRad;
    if (!rollDeg.isNaN) {
      rotRad =
          rollDeg *
          (math.pi / 180.0); // roll maps directly to in-plane rotation
    } else {
      // compute rotation from eye vector (more robust when roll isn't provided)
      final eyeVector = rightScreen - leftScreen;
      rotRad = math.atan2(eyeVector.dy, eyeVector.dx);
    }

    // Apply small blending with eye vector to stabilize rotation (optional)
    final eyeVectorRot = math.atan2(
      (rightScreen - leftScreen).dy,
      (rightScreen - leftScreen).dx,
    );
    rotRad = rotRad * 0.9 + eyeVectorRot * 0.1;

    // Apply per-model rotation offset (degrees -> radians)
    if (model != null && model.rotationOffsetDeg != 0.0) {
      rotRad += (model.rotationOffsetDeg * (math.pi / 180.0));
    }

    // Apply anchor offset in screen pixels (model-specific tuning)
    final dx = model?.anchorOffset.dx ?? 0.0;
    final dy = model?.anchorOffset.dy ?? 0.0;
    final adjustedCenter = Offset(blendedCenter.dx + dx, blendedCenter.dy + dy);

    // Smoothing (exponential) to reduce jitter
    final alpha = smoothingAlpha; // 0..1, higher is snappier
    final smoothedCenter = _prevCenter == null
        ? adjustedCenter
        : Offset.lerp(_prevCenter!, adjustedCenter, alpha)!;
    final smoothedRotation = _prevRotation == null
        ? rotRad
        : _lerpAngle(_prevRotation!, rotRad, alpha);
    final smoothedScale = _prevScale == null
        ? scale
        : (_prevScale! * (1 - alpha) + scale * alpha);

    _prevCenter = smoothedCenter;
    _prevRotation = smoothedRotation;
    _prevScale = smoothedScale;

    return TransformData(
      center: smoothedCenter,
      rotation: smoothedRotation,
      scale: smoothedScale,
    );
  }

  double _lerpAngle(double a, double b, double t) {
    // shortest-path angle lerp
    var diff = (b - a + math.pi) % (2 * math.pi) - math.pi;
    return a + diff * t;
  }

  void selectGlasses(GlassesModel g) {
    selectedGlasses.value = g;
    debugPrint('Selected glasses: ${g.id}');
    update();
  }

  // Unity message handlers
  void handleUnityMessage(String data) {
    if (data == "touch") {
      _numberOfTaps += 1;
      update();
    } else if (data == "scene_loaded") {
      // Scene loaded, can send initial data
      debugPrint('Unity scene loaded');
    } else if (data == "ar:true") {
      _isUnityArSupportedOnDevice = true;
      update();
    } else if (data == "ar:false") {
      _isUnityArSupportedOnDevice = false;
      update();
    }
  }

  void updateRotationSpeed(double speed) {
    _rotationSpeed = speed;
    update();
  }

  void toggleArScene(bool value) {
    _isArSceneActive = value;
    update();
  }

  @override
  void onClose() {
    cameraController?.dispose();
    faceDetector.close();
    super.onClose();
  }
}
