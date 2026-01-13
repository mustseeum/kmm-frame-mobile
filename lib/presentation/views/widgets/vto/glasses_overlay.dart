import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:kacamatamoo/presentation/views/screens/virtual_try_on/controllers/try_on_glasses_v2_controller.dart';

class GlassesOverlay extends StatelessWidget {
  final VirtualTryOnV2Controller controller;
  final Size
  previewSize; // **IMPORTANT** exact size of the camera preview widget
  final bool debugMode;

  const GlassesOverlay({
    Key? key,
    required this.controller,
    required this.previewSize,
    this.debugMode = false,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return Obx(() {
      final face = controller.currentFace.value;
      final glasses = controller.selectedGlasses.value;
      if (glasses == null) return const SizedBox.shrink();

      if (face == null) {
        // optionally show preview in center while waiting for detection
        return Center(child: Image.asset(glasses.assetImage, width: 160));
      }

      // Compute transform using controller helper
      final transform = controller.computeTransformFromFace(
        face,
        previewSize,
        model: glasses,
      );

      // Use only width to preserve aspect ratio of the asset
      final double baseImageWidth = 160.0; // tune per-app base width
      final double glassWidth = baseImageWidth * transform.scale;

      // Calculate left/top from center
      final left = transform.center.dx - glassWidth / 2.0;
      final top =
          transform.center.dy -
          (glassWidth *
              0.45); // 0.45 places the bridge slightly higher (tweak per model)

      final List<Widget> stackChildren = [];

      stackChildren.add(
        Positioned(
          left: left,
          top: top,
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..translate(0.0, 0.0)
              ..rotateZ(transform.rotation),
            child: Image.asset(
              glasses.assetImage,
              width: glassWidth,
              fit: BoxFit.contain,
            ),
          ),
        ),
      );

      if (debugMode) {
        // draw center marker
        stackChildren.add(
          Positioned(
            left: transform.center.dx - 4,
            top: transform.center.dy - 4,
            child: Container(width: 8, height: 8, color: Colors.red),
          ),
        );

        // show eye points
        final leftEye = face.landmarks[FaceLandmarkType.leftEye]?.position;
        final rightEye = face.landmarks[FaceLandmarkType.rightEye]?.position;
        if (leftEye != null) {
          final p = controller.cameraImageToScreen(
            Offset(leftEye.x.toDouble(), leftEye.y.toDouble()),
            previewSize,
          );
          stackChildren.add(
            Positioned(
              left: p.dx - 3,
              top: p.dy - 3,
              child: Container(width: 6, height: 6, color: Colors.blue),
            ),
          );
        }
        if (rightEye != null) {
          final p = controller.cameraImageToScreen(
            Offset(rightEye.x.toDouble(), rightEye.y.toDouble()),
            previewSize,
          );
          stackChildren.add(
            Positioned(
              left: p.dx - 3,
              top: p.dy - 3,
              child: Container(width: 6, height: 6, color: Colors.blue),
            ),
          );
        }

        // nose marker
        final nose = face.landmarks[FaceLandmarkType.noseBase]?.position;
        if (nose != null) {
          final p = controller.cameraImageToScreen(
            Offset(nose.x.toDouble(), nose.y.toDouble()),
            previewSize,
          );
          stackChildren.add(
            Positioned(
              left: p.dx - 3,
              top: p.dy - 3,
              child: Container(width: 6, height: 6, color: Colors.green),
            ),
          );
        }
      }

      return Stack(children: stackChildren);
    });
  }
}
