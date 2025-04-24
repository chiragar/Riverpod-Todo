import 'package:flutter/material.dart';

class AppNavigation {
  ///app routes
  static pushTo(Widget screen, BuildContext context) {
    Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => screen,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ));
  }

  static pushAndRemoveUntil(Widget screen, BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (_) => screen), (v) => false);
  }

  static pushAndReplace(Widget screen, BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (_) => screen));
  }

  ///web routes
  static pushTONamed(String routeName, BuildContext context) {
    Navigator.pushNamed(context, routeName);
  }

  static pushNamedAndRemoveUntil(String routeName, BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, routeName, (v) => false);
  }
}
