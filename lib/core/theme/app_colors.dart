import 'package:flutter/material.dart';

class AppColors {
  // Primary
  static const Color primary = Color(0xFF4CAF50);
  static const Color primaryDark = Color(0xFF1B5E20);
  static const Color primaryLight = Color(0xFFE8F5E9);

  // Background
  static const Color background = Color(0xFFF5F5F5);
  static final Color primaryBackground = Colors.green.shade50;

  // App Gradient
  static const Color gradientStart = Color(0xFFFAFAFA);
  static const Color gradientMid = Color(0xFFE8F8EE);
  static const Color gradientEnd = Color(0xFFDFF5E6);

  // Splash Gradient (reusing app gradient)
  static const Color splashGradientStart = gradientStart;
  static const Color splashGradientMid = gradientMid;
  static const Color splashGradientEnd = gradientEnd;

  static const Color gradientStartDark = Color(0xFF121212);
  static const Color gradientMidDark = Color(0xFF1E1E1E);
  static const Color gradientEndDark = Color(0xFF2C2C2C);

  // Splash Animation
  static const Color splashStart = Color(0xFF6A11CB);
  static const Color splashEnd = Color(0xFF2575FC);

  // Accent
  static const Color secondary = Color(0xFFFFA726);

  // Food Theme
  static const Color sandwichBun = Color(0xFFE5C290);
  static const Color tomatoRed = Color(0xFFC05C46);
  static const Color leafGreen = Color(0xFF5FA767);
  static const Color cheddarCheese = Color(0xFFF3BF53);

  // Shadows
  static const Color greenShadow = Color(0x264CAF50);
  static const Color textShadow = Color(0xFFEAA15F);

  // Base Colors
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;

  // Text
  static const Color textPrimary = Colors.black87;
  static final Color textSecondary = Colors.grey.shade600;

  // Icons
  static final Color iconMuted = Colors.green.shade400;

  // Status
  static const Color success = Colors.green;
  static const Color error = Colors.red;
  static const Color warning = Colors.orange;
}
