import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/core/constants/assets_constants.dart';
import 'package:kacamatamoo/presentation/views/widgets/painters/ring_painter.dart';
import 'package:kacamatamoo/presentation/views/screens/scanning_face/controllers/scan_face_controller.dart';
import 'package:kacamatamoo/presentation/views/widgets/question_header_widget.dart';

class ScanFaceScreen extends GetView<ScanFaceController> {
  const ScanFaceScreen({super.key});

  Widget build(BuildContext context) {
    final bgColor = const Color(
      0xFFEFF8F7,
    ); // pale teal background like the image
    final dividerColor = const Color(
      0xFF2AA6A6,
    ); // thin accent line below header
    return Scaffold(
      appBar: QuestionHeader(
        showBack: false,
        trailing: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Text('step_3_of_5'.tr, style: TextStyle(color: Colors.blue)),
        ),
      ),
      backgroundColor: bgColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Thin divider line under header
            Container(height: 2, color: dividerColor),

            // Title / explanatory text
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 18.0,
                horizontal: 24.0,
              ),
              child: Text(
                'scan_face_instruction'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  color: Color(0xFF06293D),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            // Main content: circular camera preview centered with progress ring and percentage text below
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Choose a diameter similar to image: about 55-60% of width but also constrained by height
                  final maxWidth = constraints.maxWidth;
                  final maxHeight = constraints.maxHeight;
                  final diameter = min(maxWidth * 0.55, maxHeight * 0.65);
                  final ringPadding = 10.0; // space for progress ring stroke
                  final ringSize = diameter + ringPadding * 2;

                  return Obx(() {
                    // Update overlay dimensions for face detection
                    final circleRect = Rect.fromCircle(
                      center: Offset(maxWidth / 2, maxHeight / 2),
                      radius: diameter / 2,
                    );
                    controller.updateOverlay(circleRect, Size(maxWidth, maxHeight));

                    // Build camera preview widget (or placeholder while initializing)
                    Widget cameraCircle;
                    final camCtrl = controller.cameraController;

                    // Use controller.isScanning to determine whether to show camera or placeholder
                    // IMPORTANT: use previewSize.width / previewSize.height as-is (do NOT swap).
                    if (controller.isScanning.value &&
                        camCtrl != null &&
                        controller.cameraInitialized.value &&
                        camCtrl.value.isInitialized &&
                        camCtrl.value.previewSize != null) {
                      final previewSize = camCtrl.value.previewSize!;

                      // Create the preview child sized using the previewSize (no swap).
                      Widget previewChild = SizedBox(
                        width: previewSize.width,
                        height: previewSize.height,
                        child: CameraPreview(camCtrl),
                      );

                      // Mirror the preview ONLY when controller.previewMirror is true.
                      // Set previewMirror = false for left->left (natural, non-mirrored) behavior.
                      if (controller.previewMirror.value == true) {
                        previewChild = Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.rotationY(pi),
                          child: previewChild,
                        );
                      }

                      cameraCircle = ClipOval(
                        child: SizedBox(
                          width: diameter,
                          height: diameter,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            child: previewChild,
                          ),
                        ),
                      );
                    } else {
                      // Placeholder avatar when camera not ready or not scanning
                      cameraCircle = ClipOval(
                        child: Container(
                          color: Colors.transparent,
                          child: Center(
                            child: Image.asset(
                              AssetsConstants.faceIcon,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                    }

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Progress ring + border
                              SizedBox(
                                width: ringSize,
                                height: ringSize,
                                child: CustomPaint(
                                  painter: RingPainter(
                                    progress: controller.progress.value / 100.0,
                                    borderColor: const Color(0xFFBFCFCF),
                                    progressColor: const Color(0xFF0B413F),
                                    strokeWidth: 2.0,
                                  ),
                                  child: SizedBox(
                                    width: ringSize,
                                    height: ringSize,
                                    child: Center(child: cameraCircle),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Percentage + message (e.g. "89% - Analyzing your beautiful face!")
                        if (controller.cameraInitialized.value)
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '${controller.progress.value.toInt()}%',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: const Color(0xFF06293D),
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      '  -  ${controller.faceState.value == FaceState.insideCircle ? 'analyzing_face'.tr : controller.message.value}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    color: Color(0xFF06293D),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 20),

                        // Start Scanning button (only visible when not scanning). When scanning it becomes disabled and shows "Scanning..."
                        SizedBox(
                          width: min(520.0, constraints.maxWidth * 0.6),
                          child: ElevatedButton(
                            onPressed: controller.isScanning.value
                                ? null
                                : () => controller.startScanning(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF052E2B),
                              padding: const EdgeInsets.symmetric(
                                vertical: 14.0,
                                horizontal: 20.0,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              controller.isScanning.value
                                  ? 'scanning'.tr
                                  : 'start_scanning'.tr,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}