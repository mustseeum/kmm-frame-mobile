// lib/presentation/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:kacamatamoo/core/constants/colors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainerLight,
      onPrimaryContainer: AppColors.onPrimaryContainerLight,

      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryContainerLight,
      onSecondaryContainer: AppColors.onSecondaryContainerLight,

      background: AppColors.backgroundLight,
      onBackground: AppColors.onBackgroundLight,
      surface: AppColors.surfaceLight,
      onSurface: AppColors.onSurfaceLight,

      error: AppColors.error,
      onError: AppColors.onError,
      errorContainer: AppColors.errorContainerLight,
      onErrorContainer: AppColors.onErrorContainerLight,

      outline: AppColors.outlineLight,
    ),
    scaffoldBackgroundColor: AppColors.backgroundLight,
    textTheme: _textTheme(AppColors.onBackgroundLight, AppColors.hintLight),
    inputDecorationTheme: _inputDecoration(AppColors.outlineLight, AppColors.primary, AppColors.hintLight),
    elevatedButtonTheme: _elevatedButton(AppColors.primary, AppColors.onPrimary),
    outlinedButtonTheme: _outlinedButton(AppColors.primary, AppColors.primary),
    cardTheme: _cardTheme(AppColors.surfaceLight),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainerDark,
      onPrimaryContainer: AppColors.onPrimaryContainerDark,

      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryContainerDark,
      onSecondaryContainer: AppColors.onSecondaryContainerDark,

      background: AppColors.backgroundDark,
      onBackground: AppColors.onBackgroundDark,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.onSurfaceDark,

      error: AppColors.error,
      onError: AppColors.onError,
      errorContainer: AppColors.errorContainerDark,
      onErrorContainer: AppColors.onErrorContainerDark,

      outline: AppColors.outlineDark,
    ),
    scaffoldBackgroundColor: AppColors.backgroundDark,
    textTheme: _textTheme(AppColors.onBackgroundDark, AppColors.hintDark),
    inputDecorationTheme: _inputDecoration(AppColors.outlineDark, AppColors.primary, AppColors.hintDark),
    elevatedButtonTheme: _elevatedButton(AppColors.primary, AppColors.onPrimary),
    outlinedButtonTheme: _outlinedButton(AppColors.primary, AppColors.primary),
    cardTheme: _cardTheme(AppColors.surfaceDark),
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