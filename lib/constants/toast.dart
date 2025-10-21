import 'package:flutter/material.dart';
import '../main.dart';
import 'appColors.dart';

/// Enhanced toast function with better styling and options
void showToast(
  String message, {
  Function? onTap,
  String label = "Hide",
  Color? backgroundColor,
  Duration duration = const Duration(seconds: 2),
  SnackBarAction? action,
}) {
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

  ScaffoldMessenger.of(contextKey.currentState!.context).showSnackBar(snackBar);
}

/// Legacy toast function for backward compatibility
@deprecated
toast(
  String message, {
  Function? onTap,
  String label = "Hide",
  Color backgroundColor = Colors.black,
}) {
  showToast(
    message,
    onTap: onTap,
    label: label,
    backgroundColor: backgroundColor,
  );
}

/// Success toast
void showSuccessToast(String message) {
  showToast(
    message,
    backgroundColor: AppColors.successColor,
    duration: const Duration(seconds: 3),
  );
}

/// Error toast
void showErrorToast(String message) {
  showToast(
    message,
    backgroundColor: AppColors.errorColor,
    duration: const Duration(seconds: 4),
  );
}

/// Warning toast
void showWarningToast(String message) {
  showToast(
    message,
    backgroundColor: AppColors.warningColor,
    duration: const Duration(seconds: 3),
  );
}

/// Info toast
void showInfoToast(String message) {
  showToast(
    message,
    backgroundColor: AppColors.infoColor,
    duration: const Duration(seconds: 3),
  );
}
