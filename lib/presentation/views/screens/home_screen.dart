import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/core/constants/assets_constants.dart';
import 'package:kacamatamoo/core/constants/colors.dart';
import 'package:kacamatamoo/core/utils/function_helper.dart';
import 'package:kacamatamoo/presentation/controllers/home_screen_controller.dart';
import 'package:kacamatamoo/presentation/views/widgets/heading_card_widget.dart';
import 'package:kacamatamoo/presentation/views/widgets/option_tilte_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<HomeScreenController>();
    return Scaffold(
      backgroundColor: AppColors.primaryContainerLight,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Tablet vertical detection: tweak breakpoint as needed
            final isTabletVertical =
                constraints.maxWidth >= 600 && constraints.maxWidth <= 900;
            final containerWidth = isTabletVertical
                ? constraints.maxWidth * 0.72
                : constraints.maxWidth * 0.86;
            final topLogoHeight = isTabletVertical ? 92.0 : 80.0;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top logo card
                    // heading logo and title
                    HeadingCardWidget(
                      containerWidth: containerWidth,
                      isTablet: FunctionHelper.isTablet(constraints),
                      onTap: () => ctrl.goBack(),
                    ),

                    const SizedBox(height: 28),

                    // Heading
                    Obx(
                      () => Text(
                        ctrl.titleWhenAI(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),

                    const SizedBox(height: 22),

                    // Option tiles stacked
                    SizedBox(
                      width: containerWidth,
                      child: Column(
                        children: [
                          // First tile (frame) - teal
                          Obx(
                            () => OptionTilteWidget(
                              background: const Color(0xFF63C2BF),
                              assetIcon: AssetsConstants.iconFrame,
                              title: ctrl.optionFrameTitle(),
                              subtitle: ctrl.lorem(),
                              onTap: () => ctrl.onTapOption('frame'),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Second tile (lens) - yellow
                          Obx(
                            () => OptionTilteWidget(
                              background: const Color(0xFFF7DB55),
                              assetIcon: AssetsConstants.iconLens,
                              title: ctrl.optionLensTitle(),
                              subtitle: ctrl.lorem(),
                              onTap: () => ctrl.onTapOption('lens'),
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Third tile (both) - teal
                          Obx(
                            () => OptionTilteWidget(
                              background: const Color(0xFF63C2BF),
                              assetIcon: AssetsConstants.iconBoth,
                              title: ctrl.optionBothTitle(),
                              subtitle: ctrl.lorem(),
                              onTap: () => ctrl.onTapOption('both'),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Language row (white rounded)
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.onPrimary,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.onBackgroundLight.withValues(
                                    alpha: 0.02,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 14,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8FFFA),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.language,
                                    color: Color(0xFF00897B),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Language',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                // Toggle chips for ID / EN
                                Obx(() {
                                  final lang = ctrl.language.value;
                                  return Row(
                                    children: [
                                      // ID chip
                                      GestureDetector(
                                        onTap: () =>
                                            ctrl.toggleLanguage(Language.id),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: lang == Language.id
                                                ? const Color(0xFF00897B)
                                                : Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            border: Border.all(
                                              color: const Color(0xFF00897B),
                                            ),
                                          ),
                                          child: Text(
                                            'ID',
                                            style: TextStyle(
                                              color: lang == Language.id
                                                  ? Colors.white
                                                  : const Color(0xFF00897B),
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      GestureDetector(
                                        onTap: () =>
                                            ctrl.toggleLanguage(Language.en),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: lang == Language.en
                                                ? const Color(0xFF00897B)
                                                : Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            border: Border.all(
                                              color: const Color(0xFF00897B),
                                            ),
                                          ),
                                          child: Text(
                                            'EN',
                                            style: TextStyle(
                                              color: lang == Language.en
                                                  ? Colors.white
                                                  : const Color(0xFF00897B),
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 26),

                    // Footer
                    Text(
                      'copy_right'.tr,
                      style: TextStyle(
                        fontSize: FunctionHelper.isTablet(constraints)
                            ? 14
                            : 12,
                        color: AppColors.colorText,
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
