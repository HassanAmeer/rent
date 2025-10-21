import 'package:flutter/material.dart';
import 'package:rent/main.dart';

/// Enhanced screen size utilities with better error handling and additional properties
class ScreenSize {
  static double get width {
    try {
      return MediaQuery.of(contextKey.currentState!.context).size.width;
    } catch (e) {
      return 0.0; // Fallback value
    }
  }

  static double get height {
    try {
      return MediaQuery.of(contextKey.currentState!.context).size.height;
    } catch (e) {
      return 0.0; // Fallback value
    }
  }

  static Size get size {
    try {
      return MediaQuery.of(contextKey.currentState!.context).size;
    } catch (e) {
      return Size.zero; // Fallback value
    }
  }

  static EdgeInsets get padding {
    try {
      return MediaQuery.of(contextKey.currentState!.context).padding;
    } catch (e) {
      return EdgeInsets.zero; // Fallback value
    }
  }

  static EdgeInsets get viewInsets {
    try {
      return MediaQuery.of(contextKey.currentState!.context).viewInsets;
    } catch (e) {
      return EdgeInsets.zero; // Fallback value
    }
  }

  static double get devicePixelRatio {
    try {
      return MediaQuery.of(contextKey.currentState!.context).devicePixelRatio;
    } catch (e) {
      return 1.0; // Fallback value
    }
  }

  static Brightness get platformBrightness {
    try {
      return MediaQuery.of(contextKey.currentState!.context).platformBrightness;
    } catch (e) {
      return Brightness.light; // Fallback value
    }
  }

  // Convenience getters for common screen sizes
  static bool get isSmallScreen => width < 360;
  static bool get isMediumScreen => width >= 360 && width < 768;
  static bool get isLargeScreen => width >= 768;
  static bool get isTablet => width >= 600;
  static bool get isDesktop => width >= 1024;

  // Orientation
  static Orientation get orientation {
    try {
      return MediaQuery.of(contextKey.currentState!.context).orientation;
    } catch (e) {
      return Orientation.portrait; // Fallback value
    }
  }

  static bool get isPortrait => orientation == Orientation.portrait;
  static bool get isLandscape => orientation == Orientation.landscape;

  // Safe area calculations
  static double get safeHeight => height - padding.top - padding.bottom;
  static double get safeWidth => width - padding.left - padding.right;

  // Percentage-based calculations
  static double percentWidth(double percentage) => width * (percentage / 100);
  static double percentHeight(double percentage) => height * (percentage / 100);
  static double percentSafeWidth(double percentage) =>
      safeWidth * (percentage / 100);
  static double percentSafeHeight(double percentage) =>
      safeHeight * (percentage / 100);
}
