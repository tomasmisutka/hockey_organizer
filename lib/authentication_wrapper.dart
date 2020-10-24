import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hockey_organizer/screens/login.dart';
import 'package:hockey_organizer/screens/verification.dart';
import 'package:provider/provider.dart';

import 'screens/dashboard.dart';

class AuthenticationWrapper extends StatelessWidget {
  Future<void> reloadUserInformation(User firebaseUser) async {
    await firebaseUser.reload();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser == null) {
      return LoginScreen();
    }
    reloadUserInformation(firebaseUser);
    if (firebaseUser.emailVerified == false) {
      return VerificationScreen();
    }
    return Dashboard(firebaseUser);
  }
}
