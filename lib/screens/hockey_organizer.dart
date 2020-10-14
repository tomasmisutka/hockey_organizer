import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
// import 'package:hockey_organizer/screens/login_screen.dart';
import 'package:page_transition/page_transition.dart';

class HockeyOrganizer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splashIconSize: 250,
      splash: Image.asset('assets/logo.png'),
      animationDuration: Duration(milliseconds: 250),
      splashTransition: SplashTransition.scaleTransition,
      pageTransitionType: PageTransitionType.fade,
      nextScreen: Scaffold(
        body: Container(),
      ),
    );
  }
}
