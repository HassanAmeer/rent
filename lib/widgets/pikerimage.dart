// import 'package:flutter/material.dart';

// class name extends StatelessWidget {
//   const name({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return
//     Future<void> getLostData() async {
//   final ImagePicker picker = ImagePicker();
//   final LostDataResponse response = await picker.retrieveLostData();
//   if (response.isEmpty) {
//     return;
//   }
//   final List<XFile>? files = response.files;
//   if (files != null) {
//     _handleLostFiles(files);
//   } else {
//     _handleError(response.exception);
//   }
// }
//   }
// }

import 'package:image_picker/image_picker.dart'
    show ImagePicker, LostDataResponse;

Future<void> getLostData() async {
  final ImagePicker picker = ImagePicker();
  final LostDataResponse response = await picker.retrieveLostData();
}
