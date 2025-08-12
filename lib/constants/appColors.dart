import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppColors {
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

  static Color scaffoldBgColor = Colors.grey.shade100;
  static Color btnBgColor = Colors.black;
  static Color btnIconColor = Colors.white;
}
