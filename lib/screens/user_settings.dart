import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hockey_organizer/components/actionButton.dart';
import 'package:hockey_organizer/services/authentication.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class UserSettings extends StatelessWidget {
  final User firebaseUser;
  UserSettings(this.firebaseUser);

  void onPressLogOutButton(BuildContext context) {
    context.read<AuthenticationService>().signOut().whenComplete(() => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(firebaseUser.displayName),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 50),
        child: Column(
          children: [
            Text('email address: ' + firebaseUser.email, style: TextStyle(fontSize: 16)),
            const SizedBox(height: 25),
            ActionButton(
              buttonColor: Colors.blue,
              buttonText: ThemeProvider.themeOf(context).description,
              onPressed: () => ThemeProvider.controllerOf(context).nextTheme(),
            ),
            Spacer(),
            ActionButton(onPressed: () => onPressLogOutButton(context)),
          ],
        ),
      ),
    );
  }
}
