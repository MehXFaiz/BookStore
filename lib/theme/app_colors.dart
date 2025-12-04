import 'package:flutter/material.dart';

class AppColors {
  // Greenbolt color palette - Darker version
  static const Color primaryDark = Color(0xFF0d1f1a);
  static const Color primaryDarker = Color(0xFF050a08);
  static const Color background = Color(0xFF000000); // Pure black
  static const Color accentGreen = Color(0xFF9cff2e);
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textLightGreen = Color(0xFFb8e6c9);
  static const Color cardBackground = Color(0x800d1f1a); // Semi-transparent
  static const Color textFieldBackground = Color(0xFF0d1f1a);
  
  // Gradient - Darker version
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryDark, primaryDarker, background],
  );
}
