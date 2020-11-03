import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hockey_organizer/app_localization.dart';
import 'package:hockey_organizer/services/authentication.dart';
import 'package:provider/provider.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:theme_provider/theme_provider.dart';

import 'authentication_wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseApp app = await Firebase.initializeApp();
  runApp(HockeyOrganizer(app));
}

class HockeyOrganizer extends StatelessWidget {
  final FirebaseApp firebaseApp;
  HockeyOrganizer(this.firebaseApp);

  final googleSignIn = GoogleSignIn();
  final facebookLogin = FacebookLogin();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance, googleSignIn, facebookLogin),
        ),
        StreamProvider(create: (context) => context.read<AuthenticationService>().authStateChanges),
      ],
      child: ThemeProvider(
        saveThemesOnChange: true,
        loadThemeOnInit: true,
        themes: [AppTheme.light(), AppTheme.dark()],
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
        textType: TextType.NormalText,
        textStyle: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, height: 1.5),
      ),
    );
  }
}
