import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/page_frame/base_page.dart';
import 'package:kacamatamoo/core/utilities/global_function_helper.dart';
import 'package:kacamatamoo/presentation/views/screens/startup/store_information_pages/controller/sync_information_screen_controller.dart';
import 'package:kacamatamoo/presentation/views/widgets/headers/heading_card_widget.dart';

class SyncInformationScreen extends BasePage<SyncInformationScreenController> {
  const SyncInformationScreen({super.key});

  @override
  Widget buildPage(BuildContext context) {
    final theme = Theme.of(context);
    final ctrl = Get.find<SyncInformationScreenController>();
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Consider tablet vertical when width between ~600..900 (adjust if needed)
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 28.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top Logo Card (rounded rectangle with shadow)
                    // heading logo and title
                    HeadingCardWidget(
                      containerWidth: GlobalFunctionHelper.getContainerWidth(
                        constraints,
                      ),
                      isTablet: GlobalFunctionHelper.isTablet(constraints),
                    ),

                    // Main Sync Info Card
                    Container(
                      width: GlobalFunctionHelper.getContainerWidth(
                        constraints,
                      ).clamp(320.0, 720.0),
                      padding: EdgeInsets.symmetric(
                        horizontal: GlobalFunctionHelper.isTablet(constraints)
                            ? 28.0
                            : 20.0,
                        vertical: GlobalFunctionHelper.isTablet(constraints)
                            ? 22.0
                            : 16.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 22,
                            offset: const Offset(0, 14),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Title
                          Center(
                            child: Text(
                              'store_information'.tr,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Info rows
                          Obx(
                            () => InfoRow(
                              label: 'store'.tr,
                              value: ctrl.store.value,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Obx(
                            () => InfoRow(
                              label: 'store_address'.tr,
                              value: ctrl.syncStatus.value,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Obx(
                            () => InfoRow(
                              label: 'store_phone'.tr,
                              value: ctrl.itemsSynced.value,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Obx(
                            () => InfoRow(
                              label: 'current_time'.tr,
                              value: ctrl.formattedDateTime(
                                ctrl.currentTime.value,
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Buttons: Retry & Continue (side-by-side)
                          Row(
                            children: [
                              Expanded(
                                child: Obx(
                                  () => ElevatedButton(
                                    onPressed: ctrl.isSyncing.value
                                        ? null
                                        : ctrl.logout,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF0F2E2C),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      'logout'.tr,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Obx(
                                  () => ElevatedButton(
                                    onPressed: ctrl.isSyncing.value
                                        ? null
                                        : ctrl.continueFlow,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF0F2E2C),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      'continue'.tr,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Footer
                    Text(
                      'copy_right'.tr,
                      style: TextStyle(
                        fontSize: GlobalFunctionHelper.isTablet(constraints)
                            ? 14
                            : 12,
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Simple labeled info row used inside the card
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}
