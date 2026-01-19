// ScanFaceController — platform-aware InputImage creation and robust conversion.
// Compatible with google_mlkit_face_detection ^0.12.0 and google_mlkit_commons ^0.9.0
import 'dart:async';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:kacamatamoo/core/base/page_frame/base_controller.dart';
import 'package:kacamatamoo/core/utilities/function_helper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:kacamatamoo/app/routes/screen_routes.dart';
import 'package:kacamatamoo/core/constants/constants.dart';

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

  /// Returns the appropriate display message based on face state.
  String get displayMessage {
    return faceState.value == FaceState.insideCircle
        ? 'analyzing_face'.tr
        : message.value;
  }

  Size previewWidgetSize = Size.zero;
  Rect circleRect = Rect.zero;

  RxDouble diameter = 0.0.obs;
  RxDouble ringSize = 0.0.obs;
  final double ringPadding = 10.0; // space for progress ring stroke

  final int processEveryNframes = 1;
  int _frameCounter = 0;

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

  void calculateDimensions(double maxWidth, double maxHeight) {
    final dimensions = FunctionHelper.calculateCircleDimensions(
      maxWidth,
      maxHeight,
      ringPadding: ringPadding,
    );
    diameter.value = dimensions['diameter']!;
    ringSize.value = dimensions['ringSize']!;
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
      cameraController = await FunctionHelper.initializeFrontCamera();
      frontCamera = cameraController!.description;
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
    final controller = cameraController;
    cameraController = null;
    await FunctionHelper.disposeCameraController(controller);
  }

  Future<void> _processCameraImage(CameraImage image) async {
    _frameCounter++;
    if (_processing) return;
    if (_frameCounter % processEveryNframes != 0) return;
    _processing = true;

    try {
      final sensorOrientation =
          cameraController?.description.sensorOrientation ?? 0;
          
      // Create InputImage using helper function
      final inputImage = FunctionHelper.createInputImageFromCameraImage(
        image,
        cameraController!.description,
        cameraController?.value.deviceOrientation,
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

    final faceCenter = FunctionHelper.mapFaceCoordinatesToPreview(
      faceBoundingBox: face.boundingBox,
      imageWidth: imageWidth,
      imageHeight: imageHeight,
      previewSize: previewWidgetSize,
      sensorOrientation: sensorOrientation,
      lensDirection: lensDirection,
    );

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
