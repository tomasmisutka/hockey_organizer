import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../authentication_wrapper.dart';

class IntroSplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        splashIconSize: 320,
        splash: Image.asset('assets/logo.png'),
        animationDuration: Duration(milliseconds: 250),
        splashTransition: SplashTransition.scaleTransition,
        pageTransitionType: PageTransitionType.leftToRightWithFade,
        nextScreen: AuthenticationWrapper(),
      ),
    );
  }
}
