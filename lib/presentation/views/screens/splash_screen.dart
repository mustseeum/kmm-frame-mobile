// lib/presentation/views/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/presentation/controllers/splash_screen_controller.dart';
import 'package:lottie/lottie.dart';
import 'package:kacamatamoo/core/constants/colors.dart';
import 'package:kacamatamoo/core/utils/responsive.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final controller = Get.find<SplashScreenController>();
  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isPortrait = Responsive.isPortrait(context);

    // Padding & ukuran dinamis
    final horizontalPadding = isMobile ? 24.0 : 48.0;
    final animationSize = isMobile ? 180.0 : 240.0;
    final logoFontSize = isMobile ? 26.0 : 32.0;
    final subtitleFontSize = isMobile ? 13.0 : 15.0;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight, // #f8f8f7
      body: SafeArea(
        child: Center(
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
                    'assets/animation/splash_moo.json',
                    repeat: false,
                    animate: true,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 24),

                // 🔹 Logo "KacamataMoo" dengan split warna
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Kacamata',
                        style: TextStyle(
                          fontSize: logoFontSize,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary, // teal #156061
                          fontFamily: 'SF Pro', // opsional
                        ),
                      ),
                      TextSpan(
                        text: 'Moo',
                        style: TextStyle(
                          fontSize: logoFontSize,
                          fontWeight: FontWeight.bold,
                          color: AppColors.accent, // lemon #ffde59
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // 🔹 Subtitle: "Eyewear for Everyone"
                Text(
                  'Eyewear for Everyone',
                  style: TextStyle(
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onBackgroundLight.withOpacity(0.8),
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
                        color: AppColors.secondary, // cyan #62bebf
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
