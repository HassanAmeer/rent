import 'package:flutter/material.dart';

class CustomMessageFAB extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomMessageFAB({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Colors.cyan,
      child: const Icon(Icons.message, color: Colors.white),
    );
  }
}
