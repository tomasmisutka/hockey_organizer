import 'package:flutter/material.dart';
import 'package:hockey_organizer/app_localization.dart';

import 'screens/intro_splash_screen.dart';

void main() => runApp(HockeyOrganizer());

class HockeyOrganizer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hockey Organizer',
      theme: ThemeData(fontFamily: 'AnonymousPro'),
      debugShowCheckedModeBanner: false,
      supportedLocales: AppLocalizations.supportedLocales(),
      localizationsDelegates: AppLocalizations.localizationsDelegates(),
      localeResolutionCallback: (locale, supportedLocales) =>
          AppLocalizations.localeResolutionCallback(locale, supportedLocales),
      home: IntroSplashScreen(),
    );
  }
}
