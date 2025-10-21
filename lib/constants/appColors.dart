import 'package:flutter/material.dart';

class AppColors {
  // Primary Color Palette
  static const MaterialColor mainColor =
      MaterialColor(_cyanPrimaryValue, <int, Color>{
        50: Color(0xFFE0F7FA),
        100: Color(0xFFB2EBF2),
        200: Color(0xFF80DEEA),
        300: Color(0xFF4DD0E1),
        400: Color(0xFF26C6DA),
        500: Color(_cyanPrimaryValue),
        600: Color(0xFF00ACC1),
        700: Color(0xFF0097A7),
        800: Color(0xFF00838F),
        900: Color(0xFF006064),
      });
  static const int _cyanPrimaryValue = 0xFF00BCD4;

  // Background Colors
  static Color scaffoldBgColor = Colors.grey.shade100;
  static const Color cardBgColor = Colors.white;
  static const Color inputFieldBgColor = Colors.white;

  // Button Colors
  static Color btnBgColor = Colors.black;
  static Color btnIconColor = Colors.white;
  static const Color btnSecondaryBgColor = Color(0xFF00BCD4);
  static const Color btnDisabledBgColor = Colors.grey;

  // Text Colors
  static const Color textPrimaryColor = Colors.black;
  static const Color textSecondaryColor = Colors.grey;
  static const Color textAccentColor = Color(0xFF00BCD4);

  // Status Colors
  static const Color successColor = Colors.green;
  static const Color errorColor = Colors.red;
  static const Color warningColor = Colors.orange;
  static const Color infoColor = Colors.blue;

  // Border Colors
  static const Color borderColor = Color(0xFFE0E0E0);
  static const Color focusedBorderColor = Color(0xFF00BCD4);

  // Shadow Colors
  static const Color shadowColor = Colors.black12;
  static const Color shadowColorDark = Colors.black26;

  // Loading and Progress Colors
  static const Color loaderColor = Color(0xFF00BCD4);
  static const Color shimmerBaseColor = Colors.grey;
  static const Color shimmerHighlightColor = Colors.white;

  // App Bar Colors
  static const Color appBarBgColor = Colors.white;
  static const Color appBarIconColor = Colors.black;

  // Bottom Navigation Colors
  static const Color bottomNavSelectedColor = Colors.black;
  static const Color bottomNavUnselectedColor = Colors.grey;

  // Dialog and Modal Colors
  static const Color dialogBgColor = Colors.white;
  static const Color dialogBarrierColor = Colors.black54;

  // Theme Colors for Dark Mode (if needed)
  static const Color darkScaffoldBgColor = Color(0xFF121212);
  static const Color darkCardBgColor = Color(0xFF1E1E1E);
  static const Color darkTextPrimaryColor = Colors.white;
  static const Color darkTextSecondaryColor = Colors.grey;
}
