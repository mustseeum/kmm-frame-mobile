import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:kacamatamoo/presentation/views/screens/virtual_try_on/controllers/try_on_glasses_v2_controller.dart';

class CameraPreviewWidget extends StatelessWidget {
  final VirtualTryOnV2Controller controller;

  const CameraPreviewWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final camCtrl = controller.cameraController;
    if (camCtrl == null || !camCtrl.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    // Remove the horizontal mirror transform so preview behaves like a world view:
    // when user turns head left, it appears left on the screen.
    // If you prefer selfie (mirrored) behavior, you can set controller.previewMirrored = true
    // and wrap CameraPreview with Transform.scale(-1.0, 1.0).
    return CameraPreview(camCtrl);
  }
}