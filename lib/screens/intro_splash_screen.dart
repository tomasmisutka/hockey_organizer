import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

import '../authentication_wrapper.dart';

class IntroSplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreenView(
        home: AuthenticationWrapper(),
        duration: 4000,
        imageSize: 300,
        imageSrc: "assets/hockey.png",
        text: "Hockey\n     Organizer",
        textType: TextType.NormalText,
        textStyle: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, height: 1.5),
      ),
    );
  }
}
