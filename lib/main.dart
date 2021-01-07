import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hockey_organizer/app_localization.dart';
import 'package:hockey_organizer/services/authentication.dart';
import 'package:hockey_organizer/utils/themes.dart';
import 'package:provider/provider.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:theme_provider/theme_provider.dart';

import 'authentication_wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);
  runApp(HockeyOrganizer());
}

class HockeyOrganizer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HockeyThemes themes = HockeyThemes();
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(create: (_) => AuthenticationService()),
        StreamProvider(create: (context) => context.read<AuthenticationService>().authStateChanges),
      ],
      child: ThemeProvider(
        saveThemesOnChange: true,
        loadThemeOnInit: true,
        themes: themes.getThemes(),
        child: ThemeConsumer(
          child: Builder(
            builder: (themeContext) => MaterialApp(
              builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), child: child),
              title: 'Hockey Organizer',
              theme: ThemeProvider.themeOf(themeContext).data,
              debugShowCheckedModeBanner: false,
              supportedLocales: AppLocalizations.supportedLocales(),
              localizationsDelegates: AppLocalizations.localizationsDelegates(),
              localeResolutionCallback: AppLocalizations.localeResolutionCallback,
              home: _Splash(),
            ),
          ),
        ),
      ),
    );
  }
}

class _Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreenView(
        home: AuthenticationWrapper(),
        duration: 2000,
        imageSize: 280,
        imageSrc: "assets/logo.png",
        text: 'Hockey\nOrganizer',
        textType: TextType.NormalText,
        textStyle: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, height: 1.5),
      ),
    );
  }
}
