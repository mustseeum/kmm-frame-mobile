// lib/app/app.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kacamatamoo/app/routes/app_routes.dart';
import 'package:kacamatamoo/app/routes/screen_routes.dart';
import 'package:kacamatamoo/localization/localization_service.dart';
import 'package:kacamatamoo/presentation/theme/app_themes.dart';

class KacamataMooApp extends StatelessWidget {
  const KacamataMooApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Optional: Deteksi tema sistem (bisa diubah jadi default light jika mau)
    final isDarkMode = MediaQuery.platformBrightnessOf(context) == Brightness.dark;

    return GetMaterialApp(
      title: 'KacamataMoo',
      debugShowCheckedModeBanner: false,
      // 🔹 Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light, // atau ThemeMode.light jika selalu light
      // 🔹 Tambahkan ini:
      translations: LocalizationService(),
      locale: LocalizationService.locale,
      fallbackLocale: LocalizationService.fallbackLocale,
      // 🔹 Akhir tambahan

      initialRoute: ScreenRoutes.syncScreen,
      getPages: AppRoutes.pages,
    );
  }
}