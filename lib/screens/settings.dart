import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hockey_organizer/app_localization.dart';
import 'package:hockey_organizer/services/authentication.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class Settings extends StatelessWidget {
  final User firebaseUser;
  Settings(this.firebaseUser);

  void onPressLogOutButton(BuildContext context) {
    context.read<AuthenticationService>().signOut().whenComplete(() => Navigator.of(context).pop());
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(firebaseUser.displayName),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('email address: ' + firebaseUser.email, style: TextStyle(fontSize: 16)),
            const SizedBox(height: 25),
            RaisedButton(
                child: Text(ThemeProvider.themeOf(context).description),
                onPressed: () => ThemeProvider.controllerOf(context).nextTheme()),
            Spacer(),
            RaisedButton(
              onPressed: () => onPressLogOutButton(context),
              color: Colors.red,
              elevation: 10,
              child: Text(
                appLocalizations.translate('log_out'),
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
