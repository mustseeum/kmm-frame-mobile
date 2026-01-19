import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/page_frame/base_page.dart';
import 'package:kacamatamoo/core/constants/assets_constants.dart';
import 'package:kacamatamoo/presentation/views/screens/scanning_face/controllers/scan_face_controller.dart';
import 'package:kacamatamoo/presentation/views/widgets/headers/question_header_widget.dart';
import 'package:face_scanning_id/face_scanning_id.dart';

class ScanFaceScreen extends BasePage<ScanFaceController> {
  const ScanFaceScreen({super.key});

  @override
  Widget buildPage(BuildContext context) {
    final bgColor = Theme.of(context);
    final dividerColor = const Color(0xFF2AA6A6);
    
    return Scaffold(
      appBar: QuestionHeader(
        showBack: false,
        trailing: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: Text('step_3_of_5'.tr, style: TextStyle(color: Colors.blue)),
        ),
      ),
      backgroundColor: bgColor.scaffoldBackgroundColor,
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
                  // Calculate dimensions in controller
                  controller.calculateDimensions(
                    constraints.maxWidth,
                    constraints.maxHeight,
                  );

                  return Obx(() {
                    return ScanFaceWidget(
                      diameter: controller.diameter.value,
                      ringSize: controller.ringSize.value,
                      cameraController: controller.cameraController,
                      isScanning: controller.isScanning.value,
                      cameraInitialized: controller.cameraInitialized.value,
                      previewMirror: controller.previewMirror.value,
                      progress: controller.progress.value,
                      message: controller.displayMessage,
                      placeholderIcon: AssetsConstants.faceIcon,
                      onUpdateOverlay: controller.updateOverlay,
                      onStartScanning: controller.startScanning,
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