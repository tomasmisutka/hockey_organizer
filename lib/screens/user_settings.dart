import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hockey_organizer/app_localization.dart';
import 'package:hockey_organizer/components/actionButton.dart';
import 'package:hockey_organizer/models/hockey_team_item.dart';
import 'package:hockey_organizer/services/authentication.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

class UserSettings extends StatefulWidget {
  final User firebaseUser;
  UserSettings(this.firebaseUser);

  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  HockeyTeams _teams = HockeyTeams();
  List<DropdownMenuItem<HockeyTeam>> _dropdownMenuItems;
  HockeyTeam _selectedTeam;

  @override
  void initState() {
    super.initState();
    _dropdownMenuItems = _teams.getDropdownMenuItems(context);
  }

  HockeyTeam _getSavedTheme() {
    HockeyTeam hockeyTeam = HockeyTeam('anaheim_ducks', 'Anaheim Ducks');
    for (int i = 0; i < _dropdownMenuItems.length; i++) {
      if (_dropdownMenuItems[i].value.path == ThemeProvider.themeOf(context).id) {
        hockeyTeam = _dropdownMenuItems[i].value;
      }
    }
    return hockeyTeam;
  }

  @override
  void didChangeDependencies() {
    _selectedTeam = _getSavedTheme();
    super.didChangeDependencies();
  }

  void onPressLogOutButton(BuildContext context) {
    context.read<AuthenticationService>().signOut().whenComplete(() => Navigator.of(context).pop());
  }

  Widget teamsDropdownButton(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).primaryColor, width: 2)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<HockeyTeam>(
            iconSize: 0,
            value: _selectedTeam,
            items: _dropdownMenuItems,
            onChanged: (team) {
              setState(() {
                _selectedTeam = team;
              });
              ThemeProvider.controllerOf(context).setTheme(team.path);
            },
          ),
        ));
  }

  Widget content(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    TextStyle _contentStyle = TextStyle(
        fontSize: 16,
        color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
        fontWeight: FontWeight.bold);
    return Container(
      padding: EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(appLocalizations.translate('email_address') + ': ' + widget.firebaseUser.email,
              style: _contentStyle),
          const SizedBox(height: 5),
          Text(appLocalizations.translate('name') + ': ' + widget.firebaseUser.displayName,
              style: _contentStyle),
          const SizedBox(height: 50),
          Text(appLocalizations.translate('choose_favourite_team'), style: _contentStyle),
          const SizedBox(height: 8),
          teamsDropdownButton(context),
          const SizedBox(height: 15),
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage('teams/${_selectedTeam.path}.png')))),
          ),
          const SizedBox(height: 8),
          ActionButton(onPressed: () => onPressLogOutButton(context)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:
            IconThemeData(color: Theme.of(context).floatingActionButtonTheme.foregroundColor),
        title: Text(widget.firebaseUser.displayName,
            style: TextStyle(
              color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: content(context),
    );
  }
}
