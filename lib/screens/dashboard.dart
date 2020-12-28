import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hockey_organizer/app_localization.dart';
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

  Widget userProfileIcon(BuildContext context, String url) {
    return FlatButton(
      onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ThemeConsumer(child: UserSettings(widget.firebaseUser)))),
      child: Container(
        height: 35,
        width: 35,
        margin: EdgeInsets.only(right: 10),
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
          icon: Icon(Icons.add),
          iconSize: 25,
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ThemeProvider(child: AddEventScreen(widget.firebaseUser))))),
      actions: [
        userProfileIcon(context, widget.firebaseUser.photoURL),
      ],
    );
  }

  Container sportLogo(bool isIceHockey) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: isIceHockey
                ? AssetImage('assets/ice_hockey_puck.png')
                : AssetImage('assets/inline_hockey_ball.png')),
      ),
    );
  }

  Widget content(AppLocalizations appLocalizations) {
    Query collectionReference = FirebaseFirestore.instance.collection('events').orderBy("date");
    return StreamBuilder(
      stream: collectionReference.snapshots(),
      builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, int) {
                var data = snapshot.data.docs[int].data();
                List<dynamic> loggedUsers = data['logged_players'];
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  onTap: () {},
                  title: Text(data['group_name'],
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).floatingActionButtonTheme.foregroundColor)),
                  trailing: Text(
                    loggedUsers.length.toString() + '/' + data['max_players'],
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).floatingActionButtonTheme.foregroundColor),
                  ),
                  leading: data['sport_type'] == 'ice_hockey' ? sportLogo(true) : sportLogo(false),
                );
              });
        }
        return Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final hockeyEventsDatabase = referenceDatabase.reference();
    final AppLocalizations appLocalizations = AppLocalizations.of(context);
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: chatDialog(),
      appBar: appBar(context, appLocalizations),
      floatingActionButton: floatingActionButton(),
      body: content(appLocalizations),
    );
  }
}
