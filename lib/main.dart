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
  FirebaseApp app = await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);
  runApp(HockeyOrganizer(app));
}

class HockeyOrganizer extends StatelessWidget {
  final FirebaseApp firebaseApp;
  HockeyOrganizer(this.firebaseApp);

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
              title: 'Hockey Organizer',
              theme: ThemeProvider.themeOf(themeContext).data,
              debugShowCheckedModeBanner: false,
              supportedLocales: AppLocalizations.supportedLocales(),
              localizationsDelegates: AppLocalizations.localizationsDelegates(),
              localeResolutionCallback: AppLocalizations.localeResolutionCallback,
              home: _Splash(firebaseApp),
            ),
          ),
        ),
      ),
    );
  }
}

class _Splash extends StatelessWidget {
  final FirebaseApp firebaseApp;
  _Splash(this.firebaseApp);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreenView(
        home: AuthenticationWrapper(firebaseApp),
        duration: 2000,
        imageSize: 280,
        imageSrc: "assets/hockey.png",
        text: 'Hockey\n  Organizer',
        textType: TextType.ScaleAnimatedText,
        textStyle: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, height: 1.5),
      ),
    );
  }
}
