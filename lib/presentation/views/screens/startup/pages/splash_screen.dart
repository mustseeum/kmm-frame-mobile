// lib/presentation/views/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/core/base/page_frame/base_page.dart';
import 'package:kacamatamoo/core/constants/assets_constants.dart';
import 'package:kacamatamoo/core/utils/function_helper.dart';
import 'package:kacamatamoo/presentation/views/screens/startup/controllers/splash_screen_controller.dart';
import 'package:lottie/lottie.dart';
import 'package:kacamatamoo/core/utils/responsive.dart';

class SplashScreen extends BasePage<SplashScreenController> {
  SplashScreen({super.key});

  final controller = Get.find<SplashScreenController>();
  @override
  Widget buildPage(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = Responsive.isMobile(context);
    final isPortrait = Responsive.isPortrait(context);

    // Padding & ukuran dinamis
    final horizontalPadding = isMobile ? 24.0 : 48.0;
    final animationSize = isMobile ? 180.0 : 240.0;
    final subtitleFontSize = isMobile ? 13.0 : 15.0;

    return Scaffold(
      backgroundColor: theme.colorScheme.primaryContainer,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: isMobile ? 32 : 64,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // 🔹 Animasi Lottie (AR try-on preview / playful glasses)
                    SizedBox(
                      width: animationSize,
                      height: animationSize,
                      child: Lottie.asset(
                        AssetsConstants.animationLoading,
                        repeat: false,
                        animate: true,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // 🔹 Logo "KacamataMoo" dengan split warna
                    Image.asset(
                      AssetsConstants.imageLogo,
                      width: FunctionHelper.isTablet(constraints) ? 300 : 100,
                      height: FunctionHelper.isTablet(constraints) ? 29 : 100,
                    ),
                    const SizedBox(height: 10 ),
                    // 🔹 Subtitle: "Eyewear for Everyone"
                    Text(
                      'eye_wear_for_everyone'.tr,
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    // 🔹 Pesan playful (opsional, hanya di mobile portrait)
                    if (isMobile && isPortrait)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          '✨ self-reward edition ✨',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.primary,
                          ),
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
