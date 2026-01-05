// lib/core/constants/colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // --- LIGHT MODE ---
  static const Color backgroundLight = Color(0xFFF8F8F7);
  static const Color surfaceLight = Colors.white;
  static const Color onBackgroundLight = Color(0xFF141C48);
  static const Color onSurfaceLight = Color(0xFF141C48);
  static const Color hintLight = Color(0xFF6E7C90);
  static const Color outlineLight = Color(0xFFD0D5D9);
  static const Color colorText = Color(0xFF040816);

  // Primary – Teal
  static const Color primary = Color(0xFF156061);
  static const Color primaryContainerLight = Color(0xFFEAF6F6);
  static const Color onPrimary = Colors.white;
  static const Color onPrimaryContainerLight = Color(0xFF003638);

  // Secondary – Cyan
  static const Color secondary = Color(0xFF62BEBF);
  static const Color secondaryContainerLight = Color(0xFFE0F7F7);
  static const Color onSecondary = Color(0xFF003638);
  static const Color onSecondaryContainerLight = Color(0xFF1E4E4F);

  // Accent – Lemon
  static const Color accent = Color(0xFFFFDE59);
  static const Color onAccent = Color(0xFF141C48);

  // Error (Material 3 compliant)
  static const Color error = Color(0xFFD32F2F);
  static const Color onError = Colors.white;
  static const Color errorContainerLight = Color(0xFFF9D6D6);
  static const Color onErrorContainerLight = Color(0xFF410E0B); // ✅ DITAMBAHKAN

  // --- DARK MODE ---
  static const Color backgroundDark = Color(0xFF0D1117);
  static const Color surfaceDark = Color(0xFF141C48);
  static const Color onBackgroundDark = Color(0xFFE0E6F0);
  static const Color onSurfaceDark = Colors.white;
  static const Color hintDark = Color(0xFFA0AABE);
  static const Color outlineDark = Color(0xFF4A5568);

  static const Color primaryContainerDark = Color(0xFF003638);
  static const Color onPrimaryContainerDark = Color(0xFFBCECED);

  static const Color secondaryContainerDark = Color(0xFF1E4E4F);
  static const Color onSecondaryContainerDark = Color(0xFFD0F0F0);

  static const Color errorContainerDark = Color(0xFF410E0B);
  static const Color onErrorContainerDark = Color(0xFFFFDAD6); // ✅ DITAMBAHKAN
}