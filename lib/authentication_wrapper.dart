import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hockey_organizer/screens/login.dart';
import 'package:provider/provider.dart';

import 'screens/dashboard.dart';

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser == null) {
      return LoginScreen();
    }
    firebaseUser.reload();
    return Dashboard(firebaseUser);
  }
}
