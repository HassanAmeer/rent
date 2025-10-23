import 'package:flutter/material.dart';
import '../main.dart';
import 'appColors.dart';

/// Enhanced toast function with better styling and options
void toast(
  String message, {
  Function? onTap,
  String label = "Hide",
  Color? backgroundColor,
  Duration duration = const Duration(seconds: 2),
  SnackBarAction? action,
}) {
  try {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      duration: duration,
      backgroundColor: backgroundColor ?? AppColors.textPrimaryColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.all(16),
      action:
          action ??
          (onTap != null
              ? SnackBarAction(
                  label: label,
                  textColor: Colors.white,
                  onPressed: () => onTap.call(),
                )
              : null),
    );

    // Check if the context is still valid before showing the SnackBar
    if (contextKey.currentState?.context != null &&
        contextKey.currentState!.mounted) {
      ScaffoldMessenger.of(
        contextKey.currentState!.context,
      ).showSnackBar(snackBar);
    }
  } catch (e, st) {
    debugPrint("🔥 toast try catch: error:$e");
    // debugPrint("🔥 toast try catch: error:$e, st:$st");
  }
}

/// Success toast
void showSuccessToast(String message) {
  toast(
    message,
    backgroundColor: AppColors.successColor,
    duration: const Duration(seconds: 3),
  );
}

/// Error toast
void showErrorToast(String message) {
  toast(
    message,
    backgroundColor: AppColors.errorColor,
    duration: const Duration(seconds: 4),
  );
}

/// Warning toast
void showWarningToast(String message) {
  toast(
    message,
    backgroundColor: AppColors.warningColor,
    duration: const Duration(seconds: 3),
  );
}

/// Info toast
void showInfoToast(String message) {
  toast(
    message,
    backgroundColor: AppColors.infoColor,
    duration: const Duration(seconds: 3),
  );
}
