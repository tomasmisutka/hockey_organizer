import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hockey_organizer/app_localization.dart';
import 'package:hockey_organizer/services/authentication.dart';
import 'package:provider/provider.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

import 'authentication_wrapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(HockeyOrganizer());
}

class HockeyOrganizer extends StatelessWidget {
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
      child: MaterialApp(
        title: 'Hockey Organizer',
        theme: ThemeData(fontFamily: 'IMBPlexSans'),
        debugShowCheckedModeBanner: false,
        supportedLocales: AppLocalizations.supportedLocales(),
        localizationsDelegates: AppLocalizations.localizationsDelegates(),
        localeResolutionCallback: AppLocalizations.localeResolutionCallback,
        home: _Splash(),
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
        imageSrc: "assets/hockey.png",
        text: 'Hockey\n            Organizer',
        textType: TextType.NormalText,
        textStyle: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, height: 1.5),
      ),
    );
  }
}
