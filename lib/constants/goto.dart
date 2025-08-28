import 'package:flutter/material.dart';
import 'package:rent/main.dart';
import 'package:rent/message/chat.dart';

goto(pageName, {bool canBack = true, int delayInMilliSeconds = 300}) {
  //// new with animation
  if (canBack) {
    Navigator.of(contextKey.currentState!.context).push(
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: delayInMilliSeconds),
        pageBuilder: (context, animation, secondaryAnimation) => pageName,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  } else {
    Navigator.of(contextKey.currentState!.context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: delayInMilliSeconds),
        pageBuilder: (context, animation, secondaryAnimation) => pageName,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  //// old
  // if (canBack) {
  //   Navigator.push(
  //     contextKey.currentState!.context,
  //     MaterialPageRoute(builder: (BuildContext context) => pageName),
  //   );
  // } else {
  //   Navigator.pushReplacement(
  //     contextKey.currentState!.context,
  //     MaterialPageRoute(builder: (BuildContext context) => pageName),
  //   );
  // }
}
