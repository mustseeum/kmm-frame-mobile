// lib/presentation/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:kacamatamoo/core/constants/app_colors.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: AppColors.p500, // Primary cyan/teal
      onPrimary: AppColors.n50, // White
      primaryContainer: AppColors.p100,
      onPrimaryContainer: AppColors.p900,

      secondary: AppColors.sG300, // Secondary dark blue
      onSecondary: AppColors.n50, // White
      secondaryContainer: AppColors.sG75,
      onSecondaryContainer: AppColors.sG800,

      tertiary: AppColors.a300b, // Accent yellow
      onTertiary: AppColors.sG800,
      tertiaryContainer: AppColors.a75,
      onTertiaryContainer: AppColors.a800,

      surface: AppColors.n50, // White
      onSurface: AppColors.n700, // Dark text

      error: AppColors.r400,
      onError: AppColors.n50,
      errorContainer: AppColors.r200,
      onErrorContainer: AppColors.r600,

      outline: AppColors.n200,
      outlineVariant: AppColors.n100,
    ),
    scaffoldBackgroundColor: AppColors.n75, // Light gray background
    textTheme: _textTheme(AppColors.n700, AppColors.n400),
    inputDecorationTheme: _inputDecoration(AppColors.n200, AppColors.p500, AppColors.n400),
    elevatedButtonTheme: _elevatedButton(AppColors.p500, AppColors.n50),
    outlinedButtonTheme: _outlinedButton(AppColors.p500, AppColors.p500),
    textButtonTheme: _textButton(AppColors.p500),
    cardTheme: _cardTheme(AppColors.n50),
    appBarTheme: _appBarTheme(AppColors.n50, AppColors.n700),
    floatingActionButtonTheme: _fabTheme(AppColors.p500, AppColors.n50),
    chipTheme: _chipTheme(AppColors.p100, AppColors.p700),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.p400,
      onPrimary: AppColors.p900,
      primaryContainer: AppColors.p800,
      onPrimaryContainer: AppColors.p100,

      secondary: AppColors.sG100,
      onSecondary: AppColors.sG700,
      secondaryContainer: AppColors.sG600,
      onSecondaryContainer: AppColors.sG50,

      tertiary: AppColors.a200,
      onTertiary: AppColors.a800,
      tertiaryContainer: AppColors.a700,
      onTertiaryContainer: AppColors.a50,

      surface: AppColors.n700,
      onSurface: AppColors.n100,

      error: AppColors.r400,
      onError: AppColors.n800,
      errorContainer: AppColors.r600,
      onErrorContainer: AppColors.r200,

      outline: AppColors.n500,
      outlineVariant: AppColors.n600,
    ),
    scaffoldBackgroundColor: AppColors.n800,
    textTheme: _textTheme(AppColors.n100, AppColors.n300),
    inputDecorationTheme: _inputDecoration(AppColors.n500, AppColors.p400, AppColors.n300),
    elevatedButtonTheme: _elevatedButton(AppColors.p400, AppColors.p900),
    outlinedButtonTheme: _outlinedButton(AppColors.p400, AppColors.p400),
    textButtonTheme: _textButton(AppColors.p400),
    cardTheme: _cardTheme(AppColors.n700),
    appBarTheme: _appBarTheme(AppColors.n700, AppColors.n100),
    floatingActionButtonTheme: _fabTheme(AppColors.p400, AppColors.p900),
    chipTheme: _chipTheme(AppColors.p800, AppColors.p200),
  );

  // --- Helpers ---
  static TextTheme _textTheme(Color primaryText, Color secondaryText) => TextTheme(
        displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.bold, color: primaryText),
        displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.bold, color: primaryText),
        displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: primaryText),
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: primaryText),
        headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: primaryText),
        headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: primaryText),
        titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: primaryText),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: primaryText),
        titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: primaryText),
        bodyLarge: TextStyle(fontSize: 16, color: primaryText),
        bodyMedium: TextStyle(fontSize: 14, color: primaryText),
        bodySmall: TextStyle(fontSize: 12, color: secondaryText),
        labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: primaryText),
        labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: secondaryText),
        labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: secondaryText),
      );

  static InputDecorationTheme _inputDecoration(Color outline, Color focus, Color hint) =>
      InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: focus, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.r400),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.r400, width: 2),
        ),
        hintStyle: TextStyle(color: hint),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      );

  static ElevatedButtonThemeData _elevatedButton(Color bg, Color text) => ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: text,
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          minimumSize: const Size(88, 48),
        ),
      );

  static OutlinedButtonThemeData _outlinedButton(Color border, Color text) => OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: border, width: 1.5),
          foregroundColor: text,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          minimumSize: const Size(88, 48),
        ),
      );

  static TextButtonThemeData _textButton(Color text) => TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: text,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

  static CardThemeData _cardTheme(Color surface) {
    return CardThemeData(
      color: surface,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      margin: const EdgeInsets.all(8),
    );
  }

  static AppBarTheme _appBarTheme(Color background, Color foreground) {
    return AppBarTheme(
      backgroundColor: background,
      foregroundColor: foreground,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: foreground,
      ),
      iconTheme: IconThemeData(color: foreground),
    );
  }

  static FloatingActionButtonThemeData _fabTheme(Color bg, Color fg) {
    return FloatingActionButtonThemeData(
      backgroundColor: bg,
      foregroundColor: fg,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  static ChipThemeData _chipTheme(Color bg, Color text) {
    return ChipThemeData(
      backgroundColor: bg,
      labelStyle: TextStyle(color: text, fontSize: 14),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}