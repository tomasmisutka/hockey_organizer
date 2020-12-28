import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hockey_organizer/app_localization.dart';
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
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    TextStyle _contentStyle = TextStyle(
        fontSize: 16,
        color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
        fontWeight: FontWeight.bold);
    return Scaffold(
      appBar: AppBar(
        title: Text(firebaseUser.displayName,
            style: TextStyle(
                color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
                fontWeight: FontWeight.bold)),
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(appLocalizations.translate('email_address') + ': ' + firebaseUser.email,
                style: _contentStyle),
            const SizedBox(height: 15),
            Text(appLocalizations.translate('choose_favourite_team'), style: _contentStyle),
            const SizedBox(height: 5),
            ActionButton(
              buttonColor: Colors.blue,
              buttonText: ThemeProvider.themeOf(context).description,
              onPressed: () => ThemeProvider.controllerOf(context).nextTheme(),
            ),
            const SizedBox(height: 15),
            Expanded(
                child: Container(
                    decoration: BoxDecoration(image: DecorationImage(image: AssetImage(''))))),
            ActionButton(onPressed: () => onPressLogOutButton(context)),
          ],
        ),
      ),
    );
  }
}
