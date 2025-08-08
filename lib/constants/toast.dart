import 'package:flutter/material.dart';

import '../main.dart';

toast(
  String message, {
  Function? onTap,
  String label = "Hide",
  Color backgroundColor = Colors.black,
}) {
  ScaffoldMessenger.of(contextKey.currentState!.context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: 2),
      backgroundColor: backgroundColor,
      action: SnackBarAction(
        label: label,

        onPressed: () {
          onTap?.call();
        },
      ),
    ),
  );
}
