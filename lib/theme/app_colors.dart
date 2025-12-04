import 'package:flutter/material.dart';

class AppColors {
  // Greenbolt color palette - Black to light green gradient
  static const Color primaryDark = Color(0xFF000000); // Pure black (top)
  static const Color primaryMid = Color(0xFF0a1f15); // Dark green middle
  static const Color primaryLight = Color(0xFF1a4d2e); // Lighter green (bottom)
  static const Color accentGreen = Color(0xFF9cff2e); // Bright lime green
  static const Color textWhite = Color(0xFFFFFFFF);
  static const Color textLightGreen = Color(0xFFc5f5d9); // Lighter green text
  static const Color cardBackground = Color(0x801a4d2e); // Semi-transparent light green
  static const Color textFieldBackground = Color(0xFF1a4d2e); // Lighter green
  
  // Gradient - Black (top) to Light Green (bottom)
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryDark, primaryMid, primaryLight],
  );
}
