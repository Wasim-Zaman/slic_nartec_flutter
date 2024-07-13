import 'package:flutter/material.dart';

class Navigation {
  // Navigate to a new page with animation
  static Future push(BuildContext context, Widget page) {
    return Navigator.of(context).push(_createRoute(page));
  }

  // Replace current page with a new one with animation
  static Future replace(BuildContext context, Widget page) {
    return Navigator.of(context).pushReplacement(_createRoute(page));
  }

  // Pop back to previous screen
  static void pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  // Navigate with removing all the previous routes
  static Future pushAndRemoveUntil(BuildContext context, Widget page) {
    return Navigator.of(context).pushAndRemoveUntil(
      _createRoute(page),
      (Route<dynamic> route) => false,
    );
  }

  // Custom route creation with animation
  static Route _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
