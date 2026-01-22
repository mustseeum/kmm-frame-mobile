import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/app/routes/screen_routes.dart';
import 'package:kacamatamoo/core/base/page_frame/base_page.dart';
import 'package:kacamatamoo/core/constants/app_colors.dart';
import 'package:kacamatamoo/core/constants/assets_constants.dart';
import 'package:kacamatamoo/core/constants/constants.dart';
import 'package:kacamatamoo/core/utilities/global_function_helper.dart';
import 'package:kacamatamoo/core/utilities/navigation_helper.dart';
import 'package:kacamatamoo/presentation/views/screens/startup/home_pages/controller/home_screen_controller.dart';
import 'package:kacamatamoo/presentation/views/widgets/headers/heading_card_widget.dart';
import 'package:kacamatamoo/presentation/views/widgets/other/option_tilte_widget.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends BasePage<HomeScreenController> {
  const HomeScreen({super.key});

  @override
  Widget buildPage(BuildContext context) {
    final theme = Theme.of(context);
    final ctrl = Get.find<HomeScreenController>();
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          ctrl.handleBackNavigation();
        }
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Stack(
        children: [
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Tablet vertical detection: tweak breakpoint as needed
                final isTabletVertical =
                    constraints.maxWidth >= 600 && constraints.maxWidth <= 900;
                final containerWidth = isTabletVertical
                    ? constraints.maxWidth * 0.72
                    : constraints.maxWidth * 0.86;

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
                          isTablet: GlobalFunctionHelper.isTablet(constraints),
                          onTap: () => ctrl.handleBackNavigation(),
                        ),

                        const SizedBox(height: 28),

                        // Heading
                        Obx(
                          () => Text(
                            ctrl.titleWhenAI,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 28,
                              color: AppColors.sG800,
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
                                  background: AppColors.p400,
                                  assetIcon: AssetsConstants.iconFrame,
                                  title: ctrl.optionFrameTitle,
                                  titleColor: AppColors.surface,
                                  subtitleColor: AppColors.surface,
                                  subtitle: ctrl.lorem,
                                  onTap: () => ctrl.onTapOption('frame'),
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Second tile (lens) - yellow
                              Obx(
                                () => OptionTilteWidget(
                                  background: AppColors.a300b,
                                  assetIcon: AssetsConstants.iconLens,
                                  title: ctrl.optionLensTitle,
                                  subtitle: ctrl.lorem,
                                  onTap: () => ctrl.onTapOption('lens'),
                                ),
                              ),
                              const SizedBox(height: 14),

                              // Third tile (both) - teal
                              Obx(
                                () => OptionTilteWidget(
                                  background: AppColors.p400,
                                  assetIcon: AssetsConstants.iconBoth,
                                  title: ctrl.optionBothTitle,
                                  titleColor: AppColors.surface,
                                  subtitleColor: AppColors.surface,
                                  subtitle: ctrl.lorem,
                                  onTap: () => ctrl.onTapOption('both'),
                                ),
                              ),
                              const SizedBox(height: 18),

                              // Language row (white rounded)
                              Container(
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surface,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.06,
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
                                        'change_language'.tr,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    // Language switch: ID / EN
                                    Obx(() {
                                      final lang = ctrl.language.value;
                                      final isEnglish = lang == Language.en;
                                      return Row(
                                        children: [
                                          Text(
                                            'ID',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: isEnglish
                                                  ? FontWeight.w500
                                                  : FontWeight.w700,
                                              color: isEnglish
                                                  ? theme.colorScheme.onSurface
                                                        .withValues(alpha: 0.5)
                                                  : theme.colorScheme.primary,
                                            ),
                                          ),
                                          Switch(
                                            value: isEnglish,
                                            onChanged: (value) {
                                              ctrl.toggleLanguage(
                                                value
                                                    ? Language.en
                                                    : Language.id,
                                              );
                                            },
                                            activeThumbColor:
                                                theme.colorScheme.primary,
                                          ),
                                          Text(
                                            'EN',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: isEnglish
                                                  ? FontWeight.w700
                                                  : FontWeight.w500,
                                              color: isEnglish
                                                  ? theme.colorScheme.primary
                                                  : theme.colorScheme.onSurface
                                                        .withValues(alpha: 0.5),
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

          // Loading Overlay
          Obx(
            () => ctrl.isLoading.value
                ? Container(
                    color: Colors.black.withValues(alpha: 0.5),
                    child: Center(
                      child: Lottie.asset(
                        AssetsConstants.loadingMoo,
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      ),
    );
  }
}
