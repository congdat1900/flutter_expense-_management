import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF00B2E7);
  static const Color secondary = Color(0xFFE064F7);
  static const Color tertiary = Color(0xFFFF8D6C);
  static final Color surface = Colors.grey.shade100;
  static const Color onSurface = Colors.black;
  static const Color outline = Colors.grey;
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      tertiary: AppColors.tertiary,
      outline: AppColors.outline,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.secondary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
      ),
    ),
  );
}
