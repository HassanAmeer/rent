import 'package:flutter/material.dart';
import 'package:rent/main.dart';

class ScreenSize {
  static var width = MediaQuery.of(contextKey.currentState!.context).size.width;
  static var height = MediaQuery.of(
    contextKey.currentState!.context,
  ).size.height;
}
