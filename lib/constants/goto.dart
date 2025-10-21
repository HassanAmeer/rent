import 'package:flutter/material.dart';
import 'package:rent/main.dart';
import 'package:rent/message/chat.dart';
import 'appColors.dart';

/// Enhanced navigation function with better error handling and animations
void navigateTo(
  Widget page, {
  bool canBack = true,
  int delayInMilliSeconds = 300,
  RouteSettings? settings,
}) {
  final context = contextKey.currentState?.context;
  if (context == null) {
    debugPrint('Navigation context is null');
    return;
  }

  final route = PageRouteBuilder(
    settings: settings,
    transitionDuration: Duration(milliseconds: delayInMilliSeconds),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );

  if (canBack) {
    Navigator.of(context).push(route);
  } else {
    Navigator.of(context).pushReplacement(route);
  }
}

/// Legacy goto function for backward compatibility
@deprecated
goto(pageName, {bool canBack = true, int delayInMilliSeconds = 300}) {
  navigateTo(
    pageName,
    canBack: canBack,
    delayInMilliSeconds: delayInMilliSeconds,
  );
}

/// Navigate with slide transition
void navigateWithSlide(
  Widget page, {
  bool canBack = true,
  int delayInMilliSeconds = 300,
  Offset beginOffset = const Offset(1.0, 0.0),
  Offset endOffset = Offset.zero,
}) {
  final context = contextKey.currentState?.context;
  if (context == null) {
    debugPrint('Navigation context is null');
    return;
  }

  final route = PageRouteBuilder(
    transitionDuration: Duration(milliseconds: delayInMilliSeconds),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const curve = Curves.easeInOut;
      var tween = Tween(
        begin: beginOffset,
        end: endOffset,
      ).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
  );

  if (canBack) {
    Navigator.of(context).push(route);
  } else {
    Navigator.of(context).pushReplacement(route);
  }
}

/// Navigate with scale transition
void navigateWithScale(
  Widget page, {
  bool canBack = true,
  int delayInMilliSeconds = 300,
}) {
  final context = contextKey.currentState?.context;
  if (context == null) {
    debugPrint('Navigation context is null');
    return;
  }

  final route = PageRouteBuilder(
    transitionDuration: Duration(milliseconds: delayInMilliSeconds),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn),
        ),
        child: child,
      );
    },
  );

  if (canBack) {
    Navigator.of(context).push(route);
  } else {
    Navigator.of(context).pushReplacement(route);
  }
}

/// Go back to previous screen
void goBack() {
  final context = contextKey.currentState?.context;
  if (context != null && Navigator.of(context).canPop()) {
    Navigator.of(context).pop();
  }
}

/// Go back to specific route
void goBackTo(String routeName) {
  final context = contextKey.currentState?.context;
  if (context != null) {
    Navigator.of(context).popUntil((route) => route.settings.name == routeName);
  }
}

/// Go back to home/root
void goBackToHome() {
  final context = contextKey.currentState?.context;
  if (context != null) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
