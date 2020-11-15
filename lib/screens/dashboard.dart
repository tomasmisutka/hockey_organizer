import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:hockey_organizer/app_localization.dart';
import 'package:hockey_organizer/screens/settings.dart';
import 'package:theme_provider/theme_provider.dart';

import 'add_event.dart';

class Dashboard extends StatefulWidget {
  final User firebaseUser;
  final FirebaseApp firebaseApp;

  Dashboard(this.firebaseUser, this.firebaseApp);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    final FirebaseDatabase database = FirebaseDatabase(app: widget.firebaseApp);
    _hockeyDatabaseReference = database.reference().child('HockeyEvents');
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final referenceDatabase = FirebaseDatabase.instance;
  DatabaseReference _hockeyDatabaseReference;

  Widget _buildUserProfileIcon(BuildContext context, String url) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => ThemeConsumer(child: Settings(widget.firebaseUser)))),
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

  Widget _chatDialog() {
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

  FloatingActionButton _floatingActionButtonUI() {
    return FloatingActionButton(
        onPressed: () => _scaffoldKey.currentState.openEndDrawer(),
        child: Icon(Icons.message),
        elevation: 10);
  }

  AppBar _appBarUI(BuildContext context, AppLocalizations appLocalizations,
      DatabaseReference databaseReference) {
    return AppBar(
      title: Text(appLocalizations.translate('events')),
      leading: IconButton(
          icon: Icon(Icons.add),
          iconSize: 25,
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ThemeProvider(
                      child: AddEventScreen(widget.firebaseUser, databaseReference))))),
      actions: [
        _buildUserProfileIcon(context, widget.firebaseUser.photoURL),
      ],
    );
  }

  Widget _content(AppLocalizations appLocalizations) {
    return SingleChildScrollView(
      child: FirebaseAnimatedList(
          shrinkWrap: true,
          query: _hockeyDatabaseReference,
          itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation,
              int index) {
            Map<String, dynamic> loggedUsers = Map.from(snapshot.value['Players']);
            return ListTile(
              tileColor: index % 2 == 0 ? Colors.red : Colors.grey,
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(snapshot.value['Date']),
                ],
              ),
              onTap: () {},
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(snapshot.value['Group']),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(loggedUsers.length.toString() + '/' + snapshot.value['MaxPlayers']),
                ],
              ),
            );
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hockeyEventsDatabase = referenceDatabase.reference();
    final AppLocalizations appLocalizations = AppLocalizations.of(context);
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: _chatDialog(),
      appBar: _appBarUI(context, appLocalizations, hockeyEventsDatabase),
      floatingActionButton: _floatingActionButtonUI(),
      body: _content(appLocalizations),
    );
  }
}
