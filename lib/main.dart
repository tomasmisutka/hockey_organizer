import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hockey_organizer/app_localization.dart';
import 'package:hockey_organizer/screens/intro_splash_screen.dart';
import 'package:hockey_organizer/services/authentication.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(HockeyOrganizer());
}

class HockeyOrganizer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(create: (context) => context.read<AuthenticationService>().authStateChanges),
      ],
      child: MaterialApp(
        title: 'Hockey Organizer',
        theme: ThemeData(fontFamily: 'AnonymousPro'),
        debugShowCheckedModeBanner: false,
        supportedLocales: AppLocalizations.supportedLocales(),
        localizationsDelegates: AppLocalizations.localizationsDelegates(),
        localeResolutionCallback: (locale, supportedLocales) =>
            AppLocalizations.localeResolutionCallback(locale, supportedLocales),
        home: IntroSplashScreen(),
      ),
    );
  }
}
