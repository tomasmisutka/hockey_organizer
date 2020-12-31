import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hockey_organizer/app_localization.dart';
import 'package:hockey_organizer/models/match_detail.dart';
import 'package:hockey_organizer/screens/match_detail.dart';
import 'package:hockey_organizer/screens/user_settings.dart';
import 'package:theme_provider/theme_provider.dart';

import 'add_match.dart';
import 'user_settings.dart';

class Dashboard extends StatefulWidget {
  final User firebaseUser;
  final FirebaseApp firebaseApp;

  Dashboard(this.firebaseUser, this.firebaseApp);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool currentInternetAccess = false;
  // Color tileColor = Colors.white;

  TextStyle _defaultTextStyle(BuildContext context) {
    return TextStyle(
        color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
        fontWeight: FontWeight.bold);
  }

  void assignInternetStatus() async {
    currentInternetAccess = await _checkInternetConnection();
    setState(() {});
  }

  Future<bool> _checkInternetConnection() async {
    try {
      final internetAccess = await InternetAddress.lookup('google.com');
      if (internetAccess.isNotEmpty && internetAccess[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException {
      return false;
    }
    return false;
  }

  ImageProvider getIcon(String url) {
    assignInternetStatus();
    if (url == null || currentInternetAccess == false) {
      return AssetImage('assets/icon_user.png');
    }
    return NetworkImage(url);
  }

  Widget userProfileIcon(BuildContext context, String url) {
    return FlatButton(
      onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ThemeConsumer(child: UserSettings(widget.firebaseUser)))),
      child: Container(
        height: 40,
        width: 40,
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: getIcon(url),
          ),
        ),
      ),
    );
  }

  Widget chatDialog() {
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

  FloatingActionButton floatingActionButton() {
    return FloatingActionButton(
        onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
        child: Icon(Icons.message),
        elevation: 10);
  }

  AppBar appBar(BuildContext context, AppLocalizations appLocalizations) {
    return AppBar(
      title: Text(appLocalizations.translate('matches'), style: _defaultTextStyle(context)),
      leading: IconButton(
          icon: Icon(Icons.add, color: Theme.of(context).floatingActionButtonTheme.foregroundColor),
          iconSize: 30,
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ThemeProvider(child: AddMatch(widget.firebaseUser))))),
      actions: [
        userProfileIcon(context, widget.firebaseUser.photoURL),
      ],
    );
  }

  Widget sportLogo(bool isIceHockey, String heroTag) {
    return Hero(
      tag: heroTag,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: isIceHockey
                  ? AssetImage('assets/hockey_puck.png')
                  : AssetImage('assets/hockey_ball.png')),
        ),
      ),
    );
  }

  void onHockeyEventTap(BuildContext context, Map<String, dynamic> data, String eventId) {
    MatchDetail eventDetail = MatchDetail(
        data['owner'],
        data['time'],
        data['date'],
        data['logged_players'],
        data['max_players'],
        data['place'],
        data['group_name'],
        data['sport_type']);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MatchDetailScreen(eventDetail, eventId)));
  }

  Widget content() {
    Query collectionReference = FirebaseFirestore.instance.collection('matches').orderBy("date");
    return StreamBuilder(
      stream: collectionReference.snapshots(),
      builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, int) {
                var data = snapshot.data.docs[int].data();
                String matchId = snapshot.data.docs[int].id;
                Map<String, dynamic> loggedUsers = data['logged_players'];
                return ListTile(
                  tileColor: loggedUsers.containsKey(widget.firebaseUser.uid)
                      ? Colors.greenAccent
                      : Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  onTap: () => onHockeyEventTap(context, data, matchId),
                  title: Text(data['group_name'],
                      style: _defaultTextStyle(context).copyWith(fontSize: 18)),
                  trailing: Container(
                    width: 55,
                    child: Text(
                      loggedUsers.length.toString() + '/' + data['max_players'],
                      style: _defaultTextStyle(context).copyWith(fontSize: 20),
                    ),
                  ),
                  leading: data['sport_type'] == 'ice_hockey'
                      ? sportLogo(true, matchId)
                      : sportLogo(false, matchId),
                );
              });
        }
        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context);
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: chatDialog(),
      appBar: appBar(context, appLocalizations),
      floatingActionButton: floatingActionButton(),
      body: content(),
    );
  }
}
