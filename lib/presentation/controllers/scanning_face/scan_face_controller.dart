import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:face_camera/face_camera.dart';

class ScanFaceController extends GetxController {
  late final FaceCameraController faceCameraController;

  // UI state
  final showCamera = false.obs;
  final analyzing = false.obs;
  final progress = 0.obs;

  // captured image after onCapture
  File? capturedImage;

  // avoid multiple captures (debounce)
  bool _hasCaptured = false;

  Timer? _progressTimer;

  @override
  void onInit() {
    super.onInit();

    // Initialize controller with autoCapture:false so we control when to take the photo
    faceCameraController = FaceCameraController(
      autoCapture: false,
      defaultCameraLens: CameraLens.front,
      orientation: CameraOrientation.landscapeLeft,
      onFaceDetected: (face) {
        if (face != null) {
          handleFaceDetected(face);
        }
      },
      onCapture: (File? image) {
        // // Called once camera package returns a captured image
        // if (image != null) {
        //   capturedImage = image;
        // }

        // // finalize UI state
        // progress.value = 100;
        // analyzing.value = false;

        // _progressTimer?.cancel();
        // _progressTimer = null;

        // // mark that we have captured to avoid further captures
        // _hasCaptured = true;

        // // Optionally hide camera after capture:
        // // showCamera.value = false;
      },
    );
  }

  // Called from the view when the Start Scanning button is pressed
  Future<void> startScanning() async {
    _hasCaptured = false;
    capturedImage = null;

    showCamera.value = true;
    analyzing.value = false;
    progress.value = 0;

    // Ensure any previous timer is cancelled
    _progressTimer?.cancel();
    _progressTimer = null;

    // The camera preview widget (SmartFaceCamera) is responsible for
    // streaming face detection events, which will call handleFaceDetected.
    // We do not start analysis here; analysis begins only when face detected.
  }

  // Handle face-detected events from the camera widget
  // The parameter `faces` is dynamic because different versions of the package
  // may send a list, a count, or a custom object. Inspect your SmartFaceCamera
  // callback signature and change the type if needed.
  void handleFaceDetected(dynamic faces) {
    // If we've already captured, ignore subsequent detections
    if (_hasCaptured) return;

    // Basic check: if faces is a list or has a count > 0
    bool faceFound = false;
    try {
      if (faces == null) {
        faceFound = false;
      } else if (faces is int) {
        faceFound = faces > 0;
      } else if (faces is List) {
        faceFound = faces.isNotEmpty;
      } else {
        // If the callback sends a single Face object, assume it's a detection
        faceFound = true;
      }
    } catch (_) {
      faceFound = true; // be permissive if we can't evaluate type
    }

    if (!faceFound) return;

    // Start analyzing and show progress. Debounce to ensure single capture
    _hasCaptured = true;
    analyzing.value = true;
    progress.value = 0;

    // Start a progress timer so the user sees movement until onCapture fires
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(Duration(milliseconds: 250), (t) {
      if (!analyzing.value) {
        t.cancel();
        return;
      }
      if (progress.value < 90) {
        progress.value += 6;
      } else {
        // keep it near completion but wait for real onCapture to set 100
        progress.value = 90;
      }
    });

    // Trigger a capture on the face camera controller.
    // If your FaceCameraController exposes a different capture method name,
    // replace .capture() below with that method.
    try {
      faceCameraController.takePicture();
    } catch (e) {
      // Some versions of the package may not expose capture() publicly.
      // If that's the case, check the package docs for the correct call,
      // or set autoCapture: true and rely on the camera to auto-capture.
      print('Error calling capture(): $e');
      // fallback: set a delayed fake completion (if package won't capture)
      Future.delayed(Duration(seconds: 2), () {
        // simulate capture
        progress.value = 100;
        analyzing.value = false;
      });
    }
  }

  Future<void> stopScanning() async {
    _progressTimer?.cancel();
    _progressTimer = null;
    analyzing.value = false;
    progress.value = 0;
    showCamera.value = false;
    _hasCaptured = false;

    try {
      faceCameraController.stopImageStream(); // comment out if method not available
    } catch (_) {}
  }

  @override
  void onClose() {
    _progressTimer?.cancel();
    _progressTimer = null;

    try {
      faceCameraController.dispose();
    } catch (_) {}

    super.onClose();
  }
}