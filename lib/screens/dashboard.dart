import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hockey_organizer/app_localization.dart';
import 'package:hockey_organizer/models/event_detail.dart';
import 'package:hockey_organizer/screens/event_detail.dart';
import 'package:hockey_organizer/screens/user_settings.dart';
import 'package:theme_provider/theme_provider.dart';

import 'add_event.dart';
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
      title: Text(appLocalizations.translate('events'),
          style: TextStyle(
              color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
              fontWeight: FontWeight.bold)),
      leading: IconButton(
          icon: Icon(Icons.add, color: Theme.of(context).floatingActionButtonTheme.foregroundColor),
          iconSize: 30,
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ThemeProvider(child: AddEventScreen(widget.firebaseUser))))),
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
    EventDetail eventDetail = EventDetail(
        data['owner'],
        data['time'],
        data['date'],
        data['logged_players'],
        data['max_players'],
        data['place'],
        data['group_name'],
        data['sport_type']);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HockeyEventDetail(eventDetail, eventId)));
  }

  Widget content() {
    Query collectionReference = FirebaseFirestore.instance.collection('events').orderBy("date");
    return StreamBuilder(
      stream: collectionReference.snapshots(),
      builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, int) {
                var data = snapshot.data.docs[int].data();
                String heroAnimationTag = snapshot.data.docs[int].id; //you will use that
                List<dynamic> loggedUsers = data['logged_players'];
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  onTap: () => onHockeyEventTap(context, data, heroAnimationTag),
                  title: Text(data['group_name'],
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).floatingActionButtonTheme.foregroundColor)),
                  trailing: Container(
                    width: 45,
                    child: Text(
                      loggedUsers.length.toString() + '/' + data['max_players'],
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).floatingActionButtonTheme.foregroundColor),
                    ),
                  ),
                  leading: data['sport_type'] == 'ice_hockey'
                      ? sportLogo(true, heroAnimationTag)
                      : sportLogo(false, heroAnimationTag),
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
