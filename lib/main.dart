import 'package:flutter/material.dart';

import 'screens/hockey_organizer.dart';

void main() => runApp(HockeyOrganizer());

class HockeyOrganizer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hockey Organizer',
      debugShowCheckedModeBanner: false,
      home: IntroSplashScreen(),
    );
  }
}
