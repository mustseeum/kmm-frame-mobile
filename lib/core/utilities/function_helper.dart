import 'dart:io' show Platform;

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:deepar_flutter/deepar_flutter.dart';
// import 'package:augen/augen.dart';

class FunctionHelper {
  FunctionHelper._();

  /// Determines if the current screen width is tablet size.
  ///
  /// Returns `true` if the max width is greater than or equal to 768.
  static bool isTablet(BoxConstraints constraints) {
    return constraints.maxWidth >= 768;
  }

  /// Calculates the container width based on screen size.
  ///
  /// Returns 60% of the screen width for tablets, and 92% for mobile devices.
  static double getContainerWidth(BoxConstraints constraints) {
    final isTabletSize = isTablet(constraints);
    return isTabletSize
        ? constraints.maxWidth * 0.6
        : constraints.maxWidth * 0.92;
  }

  /// Requests and handles camera permission.
  ///
  /// Returns `true` when permission is granted. If permission is permanently
  /// denied and [openSettingsIfPermanentlyDenied] is `true`, the app settings
  /// screen will be opened.
  static Future<bool> handleCameraPermission({
    bool openSettingsIfPermanentlyDenied = false,
  }) async {
    final status = await Permission.camera.status;

    if (status.isGranted) return true;

    if (status.isDenied || status.isRestricted || status.isLimited) {
      final result = await Permission.camera.request();
      return result.isGranted;
    }

    if (status.isPermanentlyDenied) {
      if (openSettingsIfPermanentlyDenied) {
        await openAppSettings();
      }
      return false;
    }

    // Fallback: request permission
    final result = await Permission.camera.request();
    return result.isGranted;
  }

  // Convert YUV_420_888 CameraImage -> NV21 (Android)
  static Uint8List convertYUV420ToNV21(CameraImage image) {
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

  // Map DeviceOrientation -> degrees used for rotation compensation
  static const Map<DeviceOrientation, int> orientationDegrees = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  /// Calculates rotation degrees for ML Kit image processing.
  ///
  /// Takes sensor orientation, device orientation, lens direction, and platform
  /// to compute the proper rotation compensation for InputImage.
  static int calculateRotationDegrees({
    required int sensorOrientation,
    required int deviceOrientationDegrees,
    required CameraLensDirection lensDirection,
  }) {
    int rotationDegrees = 0;
    if (Platform.isAndroid) {
      if (lensDirection == CameraLensDirection.front) {
        rotationDegrees = (sensorOrientation + deviceOrientationDegrees) % 360;
      } else {
        rotationDegrees =
            (sensorOrientation - deviceOrientationDegrees + 360) % 360;
      }
    } else if (Platform.isIOS) {
      rotationDegrees = sensorOrientation % 360;
    } else {
      rotationDegrees = sensorOrientation % 360;
    }
    return rotationDegrees;
  }

  /// Converts rotation degrees to InputImageRotation enum.
  static InputImageRotation getInputImageRotation(int rotationDegrees) {
    switch (rotationDegrees) {
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      case 0:
      default:
        return InputImageRotation.rotation0deg;
    }
  }

  /// Creates an InputImage from a CameraImage for ML Kit processing.
  ///
  /// Handles platform-specific image format conversion and rotation compensation.
  /// Compatible with google_mlkit_commons ^0.9.0
  static InputImage createInputImageFromCameraImage(
    CameraImage image,
    CameraDescription cameraDescription,
    DeviceOrientation? deviceOrientation,
  ) {
    final sensorOrientation = cameraDescription.sensorOrientation;
    final deviceOrientationDegrees =
        orientationDegrees[deviceOrientation ?? DeviceOrientation.portraitUp] ??
        0;

    final rotationDegrees = calculateRotationDegrees(
      sensorOrientation: sensorOrientation,
      deviceOrientationDegrees: deviceOrientationDegrees,
      lensDirection: cameraDescription.lensDirection,
    );

    final rotation = getInputImageRotation(rotationDegrees);

    late final Uint8List imageBytes;
    late final InputImageFormat inputFormat;
    late final int bytesPerRow;

    if (Platform.isAndroid) {
      imageBytes = convertYUV420ToNV21(image);
      inputFormat = InputImageFormat.nv21;
      bytesPerRow = image.planes[0].bytesPerRow;
    } else if (Platform.isIOS) {
      imageBytes = image.planes.first.bytes;
      inputFormat = InputImageFormat.bgra8888;
      bytesPerRow = image.planes[0].bytesPerRow;
    } else {
      imageBytes = convertYUV420ToNV21(image);
      inputFormat = InputImageFormat.nv21;
      bytesPerRow = image.planes[0].bytesPerRow;
    }

    final inputImageMetadata = InputImageMetadata(
      size: Size(image.width.toDouble(), image.height.toDouble()),
      rotation: rotation,
      format: inputFormat,
      bytesPerRow: bytesPerRow,
    );

    return InputImage.fromBytes(
      bytes: imageBytes,
      metadata: inputImageMetadata,
    );
  }

  /// Initializes and returns a CameraController configured for the front camera.
  ///
  /// Throws an exception if no cameras are available or initialization fails.
  static Future<CameraController> initializeFrontCamera({
    ResolutionPreset resolutionPreset = ResolutionPreset.high,
    bool enableAudio = false,
    ImageFormatGroup imageFormatGroup = ImageFormatGroup.yuv420,
  }) async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    final controller = CameraController(
      frontCamera,
      resolutionPreset,
      enableAudio: enableAudio,
      imageFormatGroup: imageFormatGroup,
    );

    await controller.initialize();
    return controller;
  }

  /// Safely disposes a CameraController.
  ///
  /// Stops image stream if running and disposes the controller.
  /// Handles errors gracefully.
  static Future<void> disposeCameraController(
    CameraController? controller,
  ) async {
    if (controller == null) return;

    try {
      try {
        await controller.stopImageStream();
      } catch (_) {
        // Stream might not be running
      }
      await controller.dispose();
    } catch (e) {
      debugPrint('Error disposing camera: $e');
    }
  }

  /// Maps face bounding box coordinates from camera image space to preview widget space.
  ///
  /// Handles rotation, mirroring, and coordinate transformation for proper overlay rendering.
  static Offset mapFaceCoordinatesToPreview({
    required Rect faceBoundingBox,
    required int imageWidth,
    required int imageHeight,
    required Size previewSize,
    required int sensorOrientation,
    required CameraLensDirection lensDirection,
  }) {
    final cx = faceBoundingBox.left + faceBoundingBox.width / 2;
    final cy = faceBoundingBox.top + faceBoundingBox.height / 2;

    double nx = cx / imageWidth;
    double ny = cy / imageHeight;

    double mappedX = nx;
    double mappedY = ny;

    final rot = sensorOrientation % 360;
    if (rot == 90) {
      mappedX = 1.0 - ny;
      mappedY = nx;
    } else if (rot == 270) {
      mappedX = ny;
      mappedY = 1.0 - nx;
    } else if (rot == 180) {
      mappedX = 1.0 - nx;
      mappedY = 1.0 - ny;
    } else {
      mappedX = nx;
      mappedY = ny;
    }

    if (lensDirection == CameraLensDirection.front) {
      mappedX = 1.0 - mappedX;
    }

    final px = (mappedX * previewSize.width).clamp(0.0, previewSize.width);
    final py = (mappedY * previewSize.height).clamp(0.0, previewSize.height);

    return Offset(px, py);
  }

  /// Calculates circle dimensions for face overlay.
  ///
  /// Returns a map with 'diameter' and 'ringSize' keys.
  static Map<String, double> calculateCircleDimensions(
    double maxWidth,
    double maxHeight, {
    double widthRatio = 0.55,
    double heightRatio = 0.65,
    double ringPadding = 10.0,
  }) {
    final diameter = (maxWidth * widthRatio < maxHeight * heightRatio)
        ? maxWidth * widthRatio
        : maxHeight * heightRatio;
    final ringSize = diameter + ringPadding * 2;
    return {'diameter': diameter, 'ringSize': ringSize};
  }
}
