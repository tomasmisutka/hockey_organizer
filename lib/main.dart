import 'package:flutter/material.dart';

import 'screens/intro_splash_screen.dart';

void main() => runApp(HockeyOrganizer());

class HockeyOrganizer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hockey Organizer',
      theme: ThemeData(
        fontFamily: 'AnonymousPro',
      ),
      debugShowCheckedModeBanner: false,
      home: IntroSplashScreen(),
    );
  }
}
