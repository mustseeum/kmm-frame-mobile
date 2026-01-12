// lib/presentation/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:kacamatamoo/core/constants/app_colors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: AppColors.fountainBlue500,
      onPrimary: Colors.white,
      primaryContainer: AppColors.fountainBlue100,
      onPrimaryContainer: AppColors.fountainBlue900,

      secondary: AppColors.fountainBlue400,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.fountainBlue200,
      onSecondaryContainer: AppColors.fountainBlue800,

      surface: Colors.white,
      onSurface: AppColors.osloGray900,

      error: const Color(0xFFD32F2F),
      onError: Colors.white,
      errorContainer: const Color(0xFFFFCDD2),
      onErrorContainer: const Color(0xFFB71C1C),

      outline: AppColors.osloGray300,
    ),
    scaffoldBackgroundColor: AppColors.osloGray50,
    textTheme: _textTheme(AppColors.osloGray900, AppColors.osloGray500),
    inputDecorationTheme: _inputDecoration(AppColors.osloGray300, AppColors.fountainBlue500, AppColors.osloGray500),
    elevatedButtonTheme: _elevatedButton(AppColors.fountainBlue500, Colors.white),
    outlinedButtonTheme: _outlinedButton(AppColors.fountainBlue500, AppColors.fountainBlue500),
    cardTheme: _cardTheme(Colors.white),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.fountainBlue400,
      onPrimary: AppColors.fountainBlue950,
      primaryContainer: AppColors.fountainBlue800,
      onPrimaryContainer: AppColors.fountainBlue100,

      secondary: AppColors.fountainBlue300,
      onSecondary: AppColors.fountainBlue950,
      secondaryContainer: AppColors.fountainBlue700,
      onSecondaryContainer: AppColors.fountainBlue200,

      surface: AppColors.osloGray900,
      onSurface: AppColors.osloGray100,

      error: const Color(0xFFEF5350),
      onError: const Color(0xFF000000),
      errorContainer: const Color(0xFFC62828),
      onErrorContainer: const Color(0xFFFFCDD2),

      outline: AppColors.osloGray700,
    ),
    scaffoldBackgroundColor: AppColors.osloGray950,
    textTheme: _textTheme(AppColors.osloGray100, AppColors.osloGray400),
    inputDecorationTheme: _inputDecoration(AppColors.osloGray700, AppColors.fountainBlue400, AppColors.osloGray400),
    elevatedButtonTheme: _elevatedButton(AppColors.fountainBlue400, AppColors.fountainBlue950),
    outlinedButtonTheme: _outlinedButton(AppColors.fountainBlue400, AppColors.fountainBlue400),
    cardTheme: _cardTheme(AppColors.osloGray900),
  );

  // --- Helpers ---
  static TextTheme _textTheme(Color primaryText, Color secondaryText) => TextTheme(
        headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryText),
        titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: primaryText),
        bodyLarge: TextStyle(fontSize: 16, color: primaryText),
        bodyMedium: TextStyle(fontSize: 14, color: secondaryText),
      );

  static InputDecorationTheme _inputDecoration(Color outline, Color focus, Color hint) =>
      InputDecorationTheme(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: outline)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: outline)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: focus, width: 2)),
        hintStyle: TextStyle(color: hint),
      );

  static ElevatedButtonThemeData _elevatedButton(Color bg, Color text) => ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: text,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)), // sesuai --corner-medium
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      );

  static OutlinedButtonThemeData _outlinedButton(Color border, Color text) => OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: border),
          foregroundColor: text,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        ),
      );

 static CardThemeData _cardTheme(Color surface) {
    return CardThemeData(
      color: surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
    );
  }
}