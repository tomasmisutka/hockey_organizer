import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hockey_organizer/app_localization.dart';
import 'package:hockey_organizer/screens/settings.dart';
import 'package:theme_provider/theme_provider.dart';

class Dashboard extends StatefulWidget {
  final User firebaseUser;

  Dashboard(this.firebaseUser);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Widget _buildUserProfileIcon(BuildContext context, String url) {
    return FlatButton(
      onPressed: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => ThemeConsumer(child: Settings(widget.firebaseUser)))),
      child: Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: url == null ? AssetImage('assets/icon_user.png') : NetworkImage(url),
          ),
        ),
      ),
    );
  }

  Widget _buildChatDialogWindow() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: _buildChatDialogWindow(),
      appBar: AppBar(
        title: Text(appLocalizations.translate('events')),
        leading: IconButton(icon: Icon(Icons.add), iconSize: 25, onPressed: () {}),
        actions: [
          _buildUserProfileIcon(context, widget.firebaseUser.photoURL),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _scaffoldKey.currentState.openEndDrawer(),
        child: Icon(Icons.message),
        elevation: 10,
      ),
      body: Container(),
    );
  }
}
