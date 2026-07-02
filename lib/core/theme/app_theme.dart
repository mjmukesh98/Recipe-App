import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSurface: Colors.black87,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    ),

    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(),
    ),

    extensions: const [
      AppGradientColors(
        start: Color(0xFFFAFAFA),
        middle: Color(0xFFE8F8EE),
        end: Color(0xFFDFF5E6),
      ),
    ],
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: const Color(0xFF121B22),

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      secondary: AppColors.secondary,

      surface: Color(0xFF1E2A24),
      onSurface: Colors.white,

      onPrimary: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1A2520),
      foregroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
    ),

    drawerTheme: const DrawerThemeData(
      backgroundColor: Color(0xFF1E2A24),
    ),

    cardTheme: const CardThemeData(
      color: Color(0xFF24342D),
      elevation: 2,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF24342D),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    extensions: const [
      AppGradientColors(
        start: Color(0xFF121B22),
        middle: Color(0xFF1E2A24),
        end: Color(0xFF2B3F36),
      ),
    ],
  );
}

class AppGradientColors extends ThemeExtension<AppGradientColors> {
  final Color start;
  final Color middle;
  final Color end;

  const AppGradientColors({
    required this.start,
    required this.middle,
    required this.end,
  });

  @override
  AppGradientColors copyWith({
    Color? start,
    Color? middle,
    Color? end,
  }) {
    return AppGradientColors(
      start: start ?? this.start,
      middle: middle ?? this.middle,
      end: end ?? this.end,
    );
  }

  @override
  AppGradientColors lerp(
      ThemeExtension<AppGradientColors>? other,
      double t,
      ) {
    if (other is! AppGradientColors) return this;

    return AppGradientColors(
      start: Color.lerp(start, other.start, t)!,
      middle: Color.lerp(middle, other.middle, t)!,
      end: Color.lerp(end, other.end, t)!,
    );
  }
}