import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

alertBoxDelete(context, {required VoidCallback onDeleteTap}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: Colors.black,
      title: const Text('Delete Order', style: TextStyle(color: Colors.white)),
      content: const Text(
        'Are you sure you want to delete this?',
        style: TextStyle(color: Colors.grey),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        TextButton(
          onPressed: () {
            // ✅ delete using ref
            onDeleteTap();

            Navigator.pop(context);
          },
          child: const Text('Delete', style: TextStyle(color: Colors.grey))
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .shimmer(color: Colors.red.shade200),
        ),
      ],
    ),
  );
}
