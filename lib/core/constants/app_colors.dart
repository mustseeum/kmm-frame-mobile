// lib/core/constants/colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // === PRIMARY COLORS ===
  static const Color p50 = Color(0xFFEAF6F6);
  static const Color p100 = Color(0xFFD4EDED);
  static const Color p200 = Color(0xFFB0DEDE);
  static const Color p300 = Color(0xFF8CCECE);
  static const Color p400 = Color(0xFF62BEBF);
  static const Color p500 = Color(0xFF44A8A9);
  static const Color p600 = Color(0xFF388E8F); // Added from P600 in image
  static const Color p700 = Color(0xFF2E7273);
  static const Color p800 = Color(0xFF235657);
  static const Color p900 = Color(0xFF173B3C);

  // === SECONDARY COLORS ===
  static const Color sG50 = Color(0xFFE9EBF4);
  static const Color sG75 = Color(0xFFC9CCE3);
  static const Color sG100 = Color(0xFFA4A9D2);
  static const Color sG200 = Color(0xFF7F86C1);
  static const Color sG300 = Color(0xFF141C48);
  static const Color sG400 = Color(0xFF11183E);
  static const Color sG500 = Color(0xFF0E1434);
  static const Color sG600 = Color(0xFF0B102A);
  static const Color sG700 = Color(0xFF070C20);
  static const Color sG800 = Color(0xFF040816);

  // === ACCENT COLORS ===
  static const Color a300 = Color(0xFFFF8D6);
  static const Color a50 = Color(0xFFFFF8D6);
  static const Color a75 = Color(0xFFFFF1AD);
  static const Color a100 = Color(0xFFFFE983);
  static const Color a200 = Color(0xFFFFE15F);
  static const Color a300b = Color(0xFFFFDE59);
  static const Color a400 = Color(0xFFE6C94F);
  static const Color a500 = Color(0xFFCCB445);
  static const Color a600 = Color(0xFFB39F3C);
  static const Color a700 = Color(0xFF998A32);
  static const Color a800 = Color(0xFF807528);

  // === NEUTRAL COLORS ===
  static const Color n50 = Color(0xFFFFFFFF);
  static const Color n75 = Color(0xFFF3F4F8);
  static const Color n100 = Color(0xFFE3E4EC);
  static const Color n200 = Color(0xFFC7C9D6);
  static const Color n300 = Color(0xFF9DA1B8);
  static const Color n400 = Color(0xFF6C7294);
  static const Color n500 = Color(0xFF4A5175);
  static const Color n600 = Color(0xFF2A325E);
  static const Color n700 = Color(0xFF141C48);
  static const Color n800 = Color(0xFF0A0F2C);

  // === FUNCTIONAL COLORS - SUCCESS (GREEN) ===
  static const Color g400 = Color(0xFF38B27D);
  static const Color g50 = Color(0xFFEAF8F2);
  static const Color g200 = Color(0xFF8FE0B8);
  static const Color g600 = Color(0xFF1F7F56);

  // === FUNCTIONAL COLORS - WARNING (ORANGE) ===
  static const Color o400 = Color(0xFFFF9F1C);
  static const Color o50 = Color(0xFFFFF4E5);
  static const Color o200 = Color(0xFFFFD199);
  static const Color o600 = Color(0xFFCC7A00);

  // === FUNCTIONAL COLORS - ERROR (RED) ===
  static const Color r400 = Color(0xFFFF4D57);
  static const Color r50 = Color(0xFFFFE9EA);
  static const Color r200 = Color(0xFFFF9FA4);
  static const Color r600 = Color(0xFFC7363F);

  // --- Utility Aliases ---
  // You can add aliases if needed, e.g.:
  static const Color primary = p500;
  static const Color secondary = sG300;
  static const Color accent = a300b;
  static const Color background = n75;
  static const Color surface = n50;
  static const Color error = r400;
  static const Color success = g400;
  static const Color warning = o400;
  
  // Additional useful aliases
  static const Color onPrimary = n50;
  static const Color onSecondary = n50;
  static const Color colorText = sG300;

  // --- Dark Mode Backgrounds ---
  static const Color darkBackground = n800;
  static const Color darkSurface = n700;
}
