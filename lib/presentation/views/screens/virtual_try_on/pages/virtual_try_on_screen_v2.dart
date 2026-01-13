import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/presentation/views/screens/virtual_try_on/controllers/try_on_glasses_v2_controller.dart';
import 'package:kacamatamoo/presentation/views/widgets/vto/camera_preview.dart';
import 'package:kacamatamoo/presentation/views/widgets/vto/glasses_overlay.dart';
import 'package:kacamatamoo/presentation/views/widgets/vto/glasses_selector.dart';

class VirtualTryOnPageV2 extends GetView<VirtualTryOnV2Controller> {
  const VirtualTryOnPageV2({super.key});

  @override
  Widget build(BuildContext context) {
    // Binding will be applied when route is created; ensure orientation locked
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return Scaffold(
      body: SafeArea(
        // Use LayoutBuilder to measure the exact preview area and pass it to the overlay.
        // This ensures the camera -> screen coordinate mapping is precise.
        child: LayoutBuilder(
          builder: (context, constraints) {
            final previewSize = Size(constraints.maxWidth, constraints.maxHeight);

            return GetBuilder<VirtualTryOnV2Controller>(
              builder: (_) => Stack(
                fit: StackFit.expand,
                children: [
                  // Camera preview (do not mirror here if you want world/window behavior).
                  CameraPreviewWidget(controller: controller),

                  // Glasses overlay - reacts to face detections and needs exact previewSize.
                  GlassesOverlay(
                    controller: controller,
                    previewSize: previewSize,
                    debugMode: true,
                  ),

                  // Bottom selector aligned bottom center
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: GlassesSelector(controller: controller),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}