// ScanFaceController — platform-aware InputImage creation and robust conversion.
// Compatible with google_mlkit_face_detection ^0.12.0 and google_mlkit_commons ^0.9.0
import 'dart:async';
import 'dart:io' show Platform;
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:kacamatamoo/core/base/page_frame/base_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:kacamatamoo/app/routes/screen_routes.dart';

enum FaceState {
  noFace,
  outsideCircle,
  multipleFaces,
  insideCircle,
  detectorError,
  cameraError,
  permissionDenied,
}

class ScanFaceController extends BaseController {
  CameraController? cameraController;
  CameraDescription? frontCamera;
  RxBool cameraInitialized = false.obs;
  RxBool previewMirror = false.obs; // false = natural left->left
  RxBool isScanning = false.obs;

  late final FaceDetector faceDetector;
  bool _processing = false;

  Rxn<Face> detectedFace = Rxn<Face>();
  RxInt faceCount = 0.obs;

  RxDouble progress = 0.0.obs;
  final double holdSecondsToComplete = 5.0;
  Timer? _progressTimer;
  Rx<FaceState> faceState = FaceState.noFace.obs;
  RxString message = 'Face not detected'.obs;

  Size previewWidgetSize = Size.zero;
  Rect circleRect = Rect.zero;

  final int processEveryNframes = 1;
  int _frameCounter = 0;

  // Map DeviceOrientation -> degrees used for rotation compensation
  static const Map<DeviceOrientation, int> _orientationDegrees = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  @override
  void onInit() {
    super.onInit();
    final options = FaceDetectorOptions(
      performanceMode: FaceDetectorMode.fast,
      enableClassification: false,
      enableLandmarks: false,
      enableContours: false,
    );
    faceDetector = FaceDetector(options: options);
    _startProgressTimer();
  }

  @override
  void onClose() {
    _stopProgressTimer();
    _stopCamera();
    faceDetector.close();
    super.onClose();
  }

  void updateOverlay(Rect circle, Size previewSize) {
    circleRect = circle;
    previewWidgetSize = previewSize;
  }

  Future<void> startScanning() async {
    if (isScanning.value) return;

    resetProgress();
    faceState.value = FaceState.noFace;
    message.value = 'Face not detected';

    final status = await Permission.camera.request();
    if (!status.isGranted) {
      faceState.value = FaceState.permissionDenied;
      message.value = 'Camera permission denied';
      return;
    }

    try {
      final cameras = await availableCameras();
      frontCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      cameraController = CameraController(
        frontCamera!,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await cameraController!.initialize();
      await cameraController!.startImageStream(_processCameraImage);

      cameraInitialized.value = true;
      isScanning.value = true;

      // default to non-mirrored preview (left->left)
      previewMirror.value = false;
    } catch (e, st) {
      faceState.value = FaceState.cameraError;
      message.value = 'Camera initialization failed';
      cameraInitialized.value = false;
      isScanning.value = false;
      debugPrint('Camera init error: $e\n$st');
    }
  }

  Future<void> stopScanning() async {
    if (!isScanning.value) return;
    isScanning.value = false;
    cameraInitialized.value = false;
    await _stopCamera();
    message.value = 'Face not detected';
  }

  Future<void> _stopCamera() async {
    try {
      if (cameraController != null) {
        final controller = cameraController;
        cameraController = null; // Clear reference immediately
        try {
          await controller!.stopImageStream();
        } catch (_) {}
        await controller?.dispose();
      }
    } catch (_) {}
  }

  // Convert YUV_420_888 CameraImage -> NV21 (Android)
  Uint8List _convertYUV420ToNV21(CameraImage image) {
    final width = image.width;
    final height = image.height;
    final planeY = image.planes[0];
    final planeU = image.planes[1];
    final planeV = image.planes[2];

    final nv21 = Uint8List(width * height + (width * height ~/ 2));
    int index = 0;

    // Copy Y plane (may include row stride padding)
    // If planeY.bytes.length == width*height then this is straightforward.
    nv21.setRange(0, planeY.bytes.length, planeY.bytes);
    index += planeY.bytes.length;

    final chromaHeight = (height / 2).floor();
    final chromaWidth = (width / 2).floor();
    final uRowStride = planeU.bytesPerRow;
    final vRowStride = planeV.bytesPerRow;
    final uPixelStride = planeU.bytesPerPixel ?? 1;
    final vPixelStride = planeV.bytesPerPixel ?? 1;

    for (var row = 0; row < chromaHeight; row++) {
      final uRowStart = row * uRowStride;
      final vRowStart = row * vRowStride;
      for (var col = 0; col < chromaWidth; col++) {
        final uIndex = uRowStart + col * uPixelStride;
        final vIndex = vRowStart + col * vPixelStride;
        final u = (uIndex < planeU.bytes.length) ? planeU.bytes[uIndex] : 0;
        final v = (vIndex < planeV.bytes.length) ? planeV.bytes[vIndex] : 0;
        nv21[index++] = v;
        nv21[index++] = u;
      }
    }
    return nv21;
  }

  Future<void> _processCameraImage(CameraImage image) async {
    _frameCounter++;
    if (_processing) return;
    if (_frameCounter % processEveryNframes != 0) return;
    _processing = true;

    try {
      // sensor orientation from camera description (degrees)
      final sensorOrientation =
          cameraController?.description.sensorOrientation ?? 0;

      // Determine device orientation compensation (based on camera value.deviceOrientation)
      int? deviceOrientationDegrees;
      try {
        deviceOrientationDegrees =
            _orientationDegrees[cameraController?.value.deviceOrientation ??
                DeviceOrientation.portraitUp];
      } catch (_) {
        deviceOrientationDegrees = 0;
      }

      // Compute rotation compensation depending on platform and lens direction
      int rotationDegrees = 0;
      if (Platform.isAndroid) {
        // Android: compute rotationCompensation using sensorOrientation and device orientation
        final rotationComp = deviceOrientationDegrees ?? 0;
        if (cameraController?.description.lensDirection ==
            CameraLensDirection.front) {
          rotationDegrees = (sensorOrientation + rotationComp) % 360;
        } else {
          rotationDegrees = (sensorOrientation - rotationComp + 360) % 360;
        }
      } else if (Platform.isIOS) {
        // iOS: typically sensorOrientation is already appropriate; we use it
        rotationDegrees = sensorOrientation % 360;
      } else {
        rotationDegrees = sensorOrientation % 360;
      }

      // Map degrees to InputImageRotation (commons ^0.9.0)
      final InputImageRotation rotation;
      switch (rotationDegrees) {
        case 90:
          rotation = InputImageRotation.rotation90deg;
          break;
        case 180:
          rotation = InputImageRotation.rotation180deg;
          break;
        case 270:
          rotation = InputImageRotation.rotation270deg;
          break;
        case 0:
        default:
          rotation = InputImageRotation.rotation0deg;
      }

      late final Uint8List imageBytes;
      late final InputImageFormat inputFormat;
      late final int bytesPerRow;

      if (Platform.isAndroid) {
        // Convert to NV21 and use NV21 format
        imageBytes = _convertYUV420ToNV21(image);
        inputFormat = InputImageFormat.nv21;
        bytesPerRow = image.planes[0].bytesPerRow;
      } else if (Platform.isIOS) {
        // iOS provides BGRA bytes typically in plane[0]
        imageBytes = image.planes.first.bytes;
        inputFormat = InputImageFormat.bgra8888;
        bytesPerRow = image.planes[0].bytesPerRow;
      } else {
        // Fallback: try NV21 conversion
        imageBytes = _convertYUV420ToNV21(image);
        inputFormat = InputImageFormat.nv21;
        bytesPerRow = image.planes[0].bytesPerRow;
      }

      // Build InputImageMetadata
      final inputImageMetadata = InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: inputFormat,
        bytesPerRow: bytesPerRow,
      );

      // Create InputImage
      final inputImage = InputImage.fromBytes(
        bytes: imageBytes,
        metadata: inputImageMetadata,
      );

      // Process faces
      final faces = await faceDetector.processImage(inputImage);

      faceCount.value = faces.length;
      if (faces.isEmpty) {
        detectedFace.value = null;
        _updateStateNoFace();
      } else if (faces.length > 1) {
        detectedFace.value = null;
        _updateStateMultipleFaces();
      } else {
        final face = faces.first;
        detectedFace.value = face;
        _evaluateFacePosition(
          face,
          image.width,
          image.height,
          cameraController?.description.lensDirection ??
              CameraLensDirection.front,
          sensorOrientation,
        );
      }
    } catch (e, st) {
      debugPrint('Face detector failed: $e');
      debugPrint('$st');

      if (kDebugMode) {
        debugPrint('Preview size: ${cameraController?.value.previewSize}');
        debugPrint(
          'Sensor orientation: ${cameraController?.description.sensorOrientation}',
        );
        try {
          for (var i = 0; i < image.planes.length; i++) {
            final p = image.planes[i];
            debugPrint(
              'Plane $i bytesPerRow=${p.bytesPerRow} bytesPerPixel=${p.bytesPerPixel} len=${p.bytes.length}',
            );
          }
        } catch (_) {}
      }

      faceState.value = FaceState.detectorError;
      message.value = 'Face detector failed';
    } finally {
      _processing = false;
    }
  }

  void _evaluateFacePosition(
    Face face,
    int imageWidth,
    int imageHeight,
    CameraLensDirection lensDirection,
    int sensorOrientation,
  ) {
    if (previewWidgetSize == Size.zero || circleRect == Rect.zero) {
      faceState.value = FaceState.noFace;
      message.value = 'Positioning...';
      return;
    }

    final bbox = face.boundingBox;
    final cx = bbox.left + bbox.width / 2;
    final cy = bbox.top + bbox.height / 2;

    // Normalize face coordinates (0.0 to 1.0)
    double nx = cx / imageWidth;
    double ny = cy / imageHeight;

    // For front camera in portrait mode, the image is typically rotated
    // Map coordinates based on sensor orientation
    double mappedX = nx;
    double mappedY = ny;

    final rot = sensorOrientation % 360;
    if (rot == 90) {
      // Portrait mode on most Android devices
      mappedX = 1.0 - ny; // Flip Y to X and invert
      mappedY = nx;
    } else if (rot == 270) {
      mappedX = ny;
      mappedY = 1.0 - nx;
    } else if (rot == 180) {
      mappedX = 1.0 - nx;
      mappedY = 1.0 - ny;
    } else {
      // 0 degrees or default
      mappedX = nx;
      mappedY = ny;
    }

    // For front camera, mirror the X coordinate (since camera is typically mirrored)
    if (lensDirection == CameraLensDirection.front) {
      mappedX = 1.0 - mappedX;
    }

    // Map to preview widget coordinates
    final px = (mappedX * previewWidgetSize.width).clamp(
      0.0,
      previewWidgetSize.width,
    );
    final py = (mappedY * previewWidgetSize.height).clamp(
      0.0,
      previewWidgetSize.height,
    );

    final faceCenter = Offset(px, py);

    // Check if face center is inside the circle
    if (circleRect.contains(faceCenter)) {
      _updateStateInsideCircle();
    } else {
      _updateStateOutsideCircle();
    }
  }

  void _updateStateNoFace() {
    faceState.value = FaceState.noFace;
    message.value = 'Face not detected';
  }

  void _updateStateMultipleFaces() {
    faceState.value = FaceState.multipleFaces;
    message.value = 'Only one face is allowed';
  }

  void _updateStateOutsideCircle() {
    faceState.value = FaceState.outsideCircle;
    message.value =
        'Make sure your face is in the center of the circle, or your face is not in the circle.';
  }

  void _updateStateInsideCircle() {
    faceState.value = FaceState.insideCircle;
    message.value = 'Hold still...';
  }

  void _startProgressTimer() {
    _progressTimer?.cancel();
    const tick = Duration(milliseconds: 100);
    _progressTimer = Timer.periodic(tick, (_) {
      if (faceState.value == FaceState.insideCircle) {
        final increment =
            100.0 / (holdSecondsToComplete * 1000 / tick.inMilliseconds);
        progress.value = (progress.value + increment).clamp(0.0, 100.0);

        // Navigate to result screen when progress reaches 100%
        if (progress.value >= 100.0) {
          _onScanComplete();
        }
      }
    });
  }

  Future<void> _onScanComplete() async {
    _stopProgressTimer();
    await stopScanning();

    // Navigate to scan result screen
    Get.toNamed(ScreenRoutes.scanResultScreen);
  }

  void _stopProgressTimer() {
    _progressTimer?.cancel();
    _progressTimer = null;
  }

  void resetProgress() {
    progress.value = 0.0;
  }
  
  @override
  void handleArguments(Map<String, dynamic> arguments) {
    // TODO: implement handleArguments
  }
}
