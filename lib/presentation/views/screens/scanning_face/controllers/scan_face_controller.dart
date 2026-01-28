// ScanFaceController — platform-aware InputImage creation and robust conversion.
// Compatible with google_mlkit_face_detection ^0.12.0 and google_mlkit_commons ^0.9.0
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:face_scanning_id/face_scanning_id.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:kacamatamoo/app/routes/screen_routes.dart';
import 'package:kacamatamoo/core/base/page_frame/base_controller.dart';
import 'package:kacamatamoo/core/constants/app_colors.dart';
import 'package:kacamatamoo/data/business_logic/ml_scan_processing_bl.dart';
import 'package:kacamatamoo/data/cache/cache_manager.dart';
import 'package:kacamatamoo/data/models/data_response/session/session_dm.dart';
import 'package:kacamatamoo/data/models/request/questionnaire/answers.dart';
import 'package:kacamatamoo/data/models/request/questionnaire/answers_data_request.dart';
import 'package:kacamatamoo/data/models/scan_result/ml_result_data/ml_result_dm.dart';
import 'package:kacamatamoo/data/models/scan_result/ml_result_data/ml_scan_processing_dm.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:kacamatamoo/core/constants/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:kacamatamoo/core/utilities/global_function_helper.dart';

class ScanFaceController extends BaseController with CacheManager {
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
  final Answers answers = Answers();
  final AnswersDataRequest answersDataRequest = AnswersDataRequest();

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

  // Questionnaire answers
  String? selectedAge;
  String? selectedGender;
  String? screenType;
  String? capturedImagePath;

  final MLScanProcessingBl _mlScanProcessingBl = MLScanProcessingBl();

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
    // _startProgressTimer();
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

    // Check AR support before starting
    final isArSupported = await GlobalFunctionHelper.checkArSupport();
    if (!isArSupported) {
      Get.snackbar(
        'AR Not Supported',
        'Your device may not fully support AR features. Virtual try-on may be limited.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.o400.withValues(alpha: 0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      isScanning.value = false;
      return;
    }

    // Restart the progress timer in case it was stopped
    _startProgressTimer();

    final status = await Permission.camera.request();
    if (!status.isGranted) {
      faceState.value = FaceState.permissionDenied;
      message.value = 'Camera permission denied';
      isScanning.value = false;
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
    resetProgress();
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

    try {
      final SessionDm session = await getSessionData();
      String sessionId = session.session_id ?? '';
      // Capture the image before stopping camera completely
      await _captureImage();

      await stopScanning();

      // Create Answers model with all questionnaire data and image
      answers.session_id = sessionId;
      answers.looking_for = selectedGender == "Men" || selectedGender == "Pria"
          ? 'men_eyewear'
          : selectedGender == "I prefer not to say" ||
                selectedGender == "Saya memilih untuk tidak menyebutkan"
          ? 'prefer_not_to_say'
          : 'women_eyewear';
      answers.age_range = GlobalFunctionHelper.formatAgeString(selectedAge);
      answers.gender_identity =
          selectedGender == "I prefer not to say" ||
              selectedGender == "Saya memilih untuk tidak menyebutkan"
          ? 'prefer_not_to_say'
          : selectedGender?.toLowerCase();

      answersDataRequest.answers = answers;
      answersDataRequest.image = capturedImagePath != null
          ? File(capturedImagePath!)
          : null;

      // Navigate to scan result screen with answers
      debugPrint(
        'Navigating to ScanResultScreen with answers: ${json.encode(answersDataRequest.toJson())}, imagePath: $capturedImagePath',
      );

      // send data to ML processing
      isLoading.value = true;
      await _mlScanProcessing(answersDataRequest);
    } catch (e, st) {
      debugPrint('Error in _onScanComplete: $e');
      debugPrint('Stack trace: $st');

      // Ensure camera is stopped and state is reset even on error
      await stopScanning();
      isLoading.value = false;

      Get.snackbar(
        'Error',
        'Failed to complete scan. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _mlScanProcessing(AnswersDataRequest answersDataRequest) async {
    try {
      final lang = Get.locale?.languageCode ?? 'en';
      final result = await _mlScanProcessingBl.processFaceScan(
        answersDataRequest,
        lang,
      );
      if (result == null) {
        debugPrint('ML scanning processing returned null result');
        Get.snackbar(
          'Error',
          'Failed to process face scan. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      } else {
        // Navigate to result screen with ML processing result
        MLScanProcessingDm mlScanProcessingDm = result;
        MLResultDM? mlResultDm = mlScanProcessingDm.ml_result;

        debugPrint(
          'MLScanProcessingRepository-log-processFaceScan-MLScanProcessingController: ${json.encode(mlResultDm)} ',
        );

        Get.toNamed(
          ScreenRoutes.scanResultScreen,
          arguments: {
            'answersData': answersDataRequest,
            'answerResult': mlResultDm,
            'imagePath': capturedImagePath,
          },
        );
      }
      debugPrint('ML Scanning Processing Result: $result');
    } catch (e, st) {
      debugPrint('Error in ML scanning processing: $e');
      debugPrint('Stack trace: $st');
    } finally {
      isLoading.value = false;
    }
  }

  void _stopProgressTimer() {
    _progressTimer?.cancel();
    _progressTimer = null;
  }

  void resetProgress() {
    progress.value = 0.0;
  }

  /// Capture image from camera when scan is complete
  Future<void> _captureImage() async {
    try {
      if (cameraController == null || !cameraController!.value.isInitialized) {
        debugPrint('Camera not initialized, cannot capture image');
        return;
      }

      // Stop image stream temporarily to take picture
      await cameraController!.stopImageStream();

      // Get temporary directory
      final directory = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final imagePath = path.join(directory.path, 'face_scan_$timestamp.jpg');

      // Take picture
      final XFile picture = await cameraController!.takePicture();

      // Copy to our desired path
      await File(picture.path).copy(imagePath);

      capturedImagePath = imagePath;
      debugPrint('Image captured successfully: $capturedImagePath');

      // Save image to device gallery (publicly accessible)
      // **uncomment the following lines if you want to save to gallery**
      final savedPath = await GlobalFunctionHelper.saveImageToGallery(
        imagePath,
        fileName: 'face_scan_$timestamp.jpg',
        albumName: 'KacamataMoo',
      );

      if (savedPath != null) {
        capturedImagePath = savedPath;
        debugPrint('Image saved to gallery: $savedPath');
      } else {
        debugPrint('Failed to save image to gallery, using temp path');
      }
    } catch (e, st) {
      debugPrint('Error capturing image: $e');
      debugPrint('Stack trace: $st');
    }
  }

  @override
  void handleArguments(Map<String, dynamic> arguments) {
    // Get questionnaire answers from previous screen
    selectedAge = arguments['selectedAge'] as String?;
    selectedGender = arguments['selectedGender'] as String?;
    screenType = arguments['screenType'] as String?;

    debugPrint('ScanFaceController received:');
    debugPrint('  selectedAge: $selectedAge');
    debugPrint('  selectedGender: $selectedGender');
    debugPrint('  screenType: $screenType');
  }
}
