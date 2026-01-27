import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/page_frame/base_page.dart';
import 'package:kacamatamoo/core/constants/assets_constants.dart';
import 'package:kacamatamoo/presentation/views/screens/scanning_face/controllers/scan_face_controller.dart';
import 'package:kacamatamoo/presentation/views/widgets/headers/question_header_widget.dart';
import 'package:face_scanning_id/face_scanning_id.dart';
import 'package:lottie/lottie.dart';

class ScanFaceScreen extends BasePage<ScanFaceController> {
  const ScanFaceScreen({super.key});

  @override
  Widget buildPage(BuildContext context) {
    final bgColor = Theme.of(context);
    final dividerColor = const Color(0xFF2AA6A6);

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: bgColor.scaffoldBackgroundColor,
        appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30+ kToolbarHeight),
        child: QuestionHeader(
          backgroundColor: bgColor.appBarTheme.backgroundColor ?? Colors.white,
          dividerColor: dividerColor,
          showDivider: true,
          trailing: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Text(
                controller.screenType == "both"
                    ? 'step_1_of_10'.tr
                    : 'step_3_of_5'.tr,
                style: const TextStyle(color: Colors.blue),
              ),
            ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
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
                      // Safety check: ensure dimensions are valid before rendering
                      // This prevents RenderBox layout issues
                      final diameter = controller.diameter.value;
                      final ringSize = controller.ringSize.value;
                      
                      if (diameter <= 0 || ringSize <= 0) {
                        // Return a placeholder while dimensions are being calculated
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      // Additional safety: if camera is scanning but not initialized,
                      // ensure we don't render until preview size is available
                      final camCtrl = controller.cameraController;
                      if (controller.isScanning.value && 
                          camCtrl != null && 
                          controller.cameraInitialized.value &&
                          camCtrl.value.isInitialized &&
                          camCtrl.value.previewSize != null) {
                        final previewSize = camCtrl.value.previewSize!;
                        // Validate preview size has non-zero dimensions
                        if (previewSize.width <= 0 || previewSize.height <= 0) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CircularProgressIndicator(),
                                const SizedBox(height: 16),
                                Text(
                                  'Initializing camera...',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).textTheme.bodyMedium?.color,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      }

                      return ScanFaceWidget(
                        diameter: diameter,
                        ringSize: ringSize,
                        cameraController: controller.cameraController,
                        isScanning: controller.isScanning.value,
                        cameraInitialized: controller.cameraInitialized.value,
                        previewMirror: controller.previewMirror.value,
                        progress: controller.progress.value,
                        message: controller.displayMessage,
                        placeholderIcon: AssetsConstants.faceIconCircle,
                        onUpdateOverlay: controller.updateOverlay,
                        onStartScanning: controller.startScanning,
                      );
                    });
                  },
                ),
              ),
            ],
          ),

          // Loading overlay with Lottie animation
          Obx(() {
            if (!controller.isLoading.value) return const SizedBox.shrink();

            return Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: Center(
                child: Lottie.asset(
                  AssetsConstants.loadingMoo,
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
            );
          }),
        ],
      ),
      ),
    );
  }
}
