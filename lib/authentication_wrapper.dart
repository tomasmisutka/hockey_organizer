import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hockey_organizer/screens/login.dart';
import 'package:hockey_organizer/screens/verification.dart';
import 'package:provider/provider.dart';

import 'screens/dashboard.dart';

class AuthenticationWrapper extends StatelessWidget {
  final FirebaseApp firebaseApp;
  AuthenticationWrapper(this.firebaseApp);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser == null) {
      return LoginScreen();
    }
    firebaseUser.reload();
    if (firebaseUser.providerData[0].providerId == 'facebook.com' ||
        firebaseUser.emailVerified == true) {
      return Dashboard(firebaseUser, firebaseApp);
    }
    return VerificationScreen();
  }
}
