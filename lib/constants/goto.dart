import 'package:flutter/material.dart';
import 'package:rent/main.dart';

goto(pageName, {bool canBack = true}) {
  if (canBack) {
    Navigator.push(
      contextKey.currentState!.context,
      MaterialPageRoute(builder: (BuildContext context) => pageName),
    );
  } else {
    Navigator.pushReplacement(
      contextKey.currentState!.context,
      MaterialPageRoute(builder: (BuildContext context) => pageName),
    );
  }
}
