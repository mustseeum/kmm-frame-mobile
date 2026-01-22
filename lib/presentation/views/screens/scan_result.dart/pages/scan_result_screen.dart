import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/page_frame/base_page.dart';
import 'package:kacamatamoo/core/constants/app_colors.dart';
import 'package:kacamatamoo/presentation/views/screens/scan_result.dart/controllers/scan_result_controller.dart';
import 'package:kacamatamoo/presentation/views/widgets/cards/profile_card.dart';
import 'package:kacamatamoo/presentation/views/widgets/other/info_tile.dart';
import 'package:kacamatamoo/core/constants/assets_constants.dart';
import 'package:kacamatamoo/presentation/views/widgets/headers/question_header_widget.dart';
import 'package:kacamatamoo/presentation/views/widgets/other/circular_image_widget.dart';

class ScanResultScreen extends BasePage<ScanResultController> {
  const ScanResultScreen({super.key});

  @override
  Widget buildPage(BuildContext context) {
    final controller = Get.find<ScanResultController>();
    return Scaffold(
      backgroundColor: AppColors.p50,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30 + kToolbarHeight),
        child: QuestionHeader(
          trailing: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Text('step_4_of_5'.tr, style: TextStyle(color: Colors.blue)),
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile = controller.profile.value;

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 28.0,
              vertical: 12.0,
            ),
            child: Column(
              children: [
                const SizedBox(height: 18),

                Text(
                  'analyze_completed'.tr,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF06293D),
                  ),
                ),
                const SizedBox(height: 18),

                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      final height = constraints.maxHeight;

                      final leftWidth = width * 0.55;
                      final rightWidth = width - leftWidth - 24;

                      final avatarDiameter = (leftWidth * 0.95).clamp(
                        220.0,
                        height * 0.95,
                      );

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // LEFT: large image area
                          profile?.imagePath != null
                              ? CircularImageWidget(
                                  imagePath: profile!.imagePath,
                                  width: leftWidth,
                                  diameter: avatarDiameter,
                                )
                              : SizedBox(
                                  width: leftWidth,
                                  height: avatarDiameter,
                                  child: Image.asset(
                                    AssetsConstants.faceIconOval,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                          const SizedBox(width: 24),

                          // RIGHT: information cards (read-only)
                          SizedBox(
                            width: rightWidth,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Face Profile
                                  ProfileCard(
                                    title: 'face_profile'.tr,
                                    icon: Icons.account_circle,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: InfoTile(
                                              label: 'face_shape'.tr,
                                              value: profile?.faceShape ?? '-',
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: InfoTile(
                                              label: 'skin_tone'.tr,
                                              value: profile?.skinTone ?? '-',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // Measurement
                                  ProfileCard(
                                    title: 'measurement'.tr,
                                    icon: Icons.straighten,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: InfoTile(
                                              label: 'face_width'.tr,
                                              value: controller.formatMm(
                                                profile?.faceWidth,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: InfoTile(
                                              label: 'eye_length'.tr,
                                              value: controller.formatMm(
                                                profile?.eyeLength,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: InfoTile(
                                              label: 'eye_width'.tr,
                                              value: controller.formatMm(
                                                profile?.eyeWidth,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: InfoTile(
                                              label: 'eye_height'.tr,
                                              value: controller.formatMm(
                                                profile?.eyeHeight,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: InfoTile(
                                              label: 'bridge'.tr,
                                              value: controller.formatMm(
                                                profile?.bridge,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: InfoTile(
                                              label: 'temple_length'.tr,
                                              value: controller.formatMm(
                                                profile?.templeLength,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // Perfect Match
                                  ProfileCard(
                                    title: 'perfect_match'.tr,
                                    icon: Icons.style,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: InfoTile(
                                              label: 'frame'.tr,
                                              value:
                                                  profile?.suggestedFrame ??
                                                  '-',
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: InfoTile(
                                              label: 'color'.tr,
                                              value:
                                                  profile?.suggestedColor ??
                                                  '-',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 28),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton.icon(
                      onPressed: controller.retakeScan,
                      icon: const Icon(Icons.arrow_back),
                      label: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Text(
                          'retake_scan'.tr,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.black12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: controller.tryOnMyself,
                      icon: const Icon(Icons.arrow_forward, color: Colors.white),
                      iconAlignment: IconAlignment.end,
                      style: OutlinedButton.styleFrom(
                        backgroundColor: const Color(0xFF0B413F),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      label: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Obx(() {
                          if (controller.tryingOn.value) {
                            return const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            );
                          }
                          return Text(
                            'try_on_myself'.tr,
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        }),
      ),
    );
  }
}
