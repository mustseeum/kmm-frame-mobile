import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/core/constants/colors.dart';
import 'package:kacamatamoo/core/utils/function_helper.dart';
import 'package:kacamatamoo/presentation/controllers/sync_information_screen_controller.dart';
import 'package:kacamatamoo/presentation/views/widgets/heading_card_widget.dart';

class SyncInfotmationScreen extends StatelessWidget {
  const SyncInfotmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<SyncInformationScreenController>();
    return Scaffold(
      backgroundColor: AppColors.primaryContainerLight,
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
                      containerWidth: FunctionHelper.getContainerWidth(constraints),
                      isTablet: FunctionHelper.isTablet(constraints),
                    ),

                    // Main Sync Info Card
                    Container(
                      width: FunctionHelper.getContainerWidth(constraints).clamp(320.0, 720.0),
                      padding: EdgeInsets.symmetric(
                        horizontal: FunctionHelper.isTablet(constraints) ? 28.0 : 20.0,
                        vertical: FunctionHelper.isTablet(constraints) ? 22.0 : 16.0,
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
                              'Sync Information',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF0B1314),
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Info rows
                          Obx(
                            () => InfoRow(
                              label: 'Store:',
                              value: ctrl.store.value,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Obx(
                            () => InfoRow(
                              label: 'Sync Status:',
                              value: ctrl.syncStatus.value,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Obx(
                            () => InfoRow(
                              label: 'Items Synced:',
                              value: ctrl.itemsSynced.value,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Obx(
                            () => InfoRow(
                              label: 'Last Updated:',
                              value: ctrl.formattedDateTime(
                                ctrl.lastUpdated.value,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Obx(
                            () => InfoRow(
                              label: 'Current Time:',
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
                                        : ctrl.retry,
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
                                      'Retry',
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
                                      'Continue',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                )
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Logout (full width)
                          ElevatedButton(
                            onPressed: ctrl.logout,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0F2E2C),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Logout',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Footer
                    const Text(
                      '2025 KACAMATAMOO. All rights reserved.',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
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
