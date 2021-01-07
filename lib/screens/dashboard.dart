import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hockey_organizer/app_localization.dart';
import 'package:hockey_organizer/models/match_detail.dart';
import 'package:hockey_organizer/models/message.dart';
import 'package:hockey_organizer/screens/match_detail.dart';
import 'package:hockey_organizer/screens/user_settings.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:theme_provider/theme_provider.dart';

import 'add_match.dart';
import 'user_settings.dart';

class Dashboard extends StatefulWidget {
  final User firebaseUser;

  Dashboard(this.firebaseUser);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool currentInternetAccess = false;
  User get firebaseUser => widget.firebaseUser;
  TextEditingController _messageController = TextEditingController();
  FocusNode _messageNode = FocusNode();

  TextStyle _defaultTextStyle(BuildContext context) {
    return TextStyle(
        color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
        fontWeight: FontWeight.bold);
  }

  void unFocusMessageTextField() => _messageNode.unfocus();

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
      onPressed: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => ThemeConsumer(child: UserSettings(firebaseUser)))),
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

  Widget chatHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            iconSize: 30,
            onPressed: () {
              _messageController.clear();
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text('Messenger', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40)),
            ),
          ),
        ],
      ),
    );
  }

  Widget messages(BuildContext context, AppLocalizations appLocalizations) {
    Query _messagesReference =
        FirebaseFirestore.instance.collection('messenger').orderBy('time', descending: true);
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(10),
        child: StreamBuilder(
          stream: _messagesReference.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Container(
                  child: Center(
                      child: CircularProgressIndicator(
                          backgroundColor: Theme.of(context).primaryColor)));
            if (!snapshot.hasData)
              return Container(
                child: Center(
                  child: Text(appLocalizations.translate('no_message')),
                ),
              );
            var data = snapshot.data;
            print('data');
            Message message = Message(data['uid'], data['name'], data['time'], data['body']);
            print(message.body);
            return Container(
              child: Text(message.body),
            );
          },
        ),
      ),
    );
  }

  String formatDate(DateTime dateTime) => DateFormat('dd.MM.yyyy kk:mm').format(dateTime);

  Widget chatInputMessage(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              focusNode: _messageNode,
              style: TextStyle(fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                hintText: appLocalizations.translate('enter_message'),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(width: 2, color: Theme.of(context).primaryColor),
                ),
                labelText: appLocalizations.translate('message'),
              ),
              keyboardType: TextInputType.text,
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              Message messageToSend = Message(firebaseUser.uid, firebaseUser.displayName,
                  formatDate(DateTime.now()), _messageController.text.trim());
              messageToSend.sendMessage();
              _messageController.clear();
            },
            child: Container(
              decoration:
                  BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle),
              child: Icon(Icons.send, color: Colors.white),
              padding: EdgeInsets.all(8),
            ),
          )
        ],
      ),
    );
  }

  Widget chat(BuildContext context, AppLocalizations appLocalizations) {
    return GestureDetector(
      onTap: unFocusMessageTextField,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.92,
        height: MediaQuery.of(context).size.height * 0.95,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12))),
        child: Column(
          children: [
            chatHeader(context),
            messages(context, appLocalizations),
            chatInputMessage(context),
          ],
        ),
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
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => ThemeProvider(child: AddMatch(firebaseUser))))),
      actions: [
        userProfileIcon(context, firebaseUser.photoURL),
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
        context,
        MaterialPageRoute(
            builder: (context) => MatchDetailScreen(eventDetail, eventId, firebaseUser)));
  }

  Color tileColor(var data) {
    if (firebaseUser.uid == data['owner']) return Colors.yellowAccent[100];
    if (data['logged_players'].containsKey(firebaseUser.uid)) return Colors.greenAccent;
    return Colors.white;
  }

  void onPressDeleteMatchButton(
      BuildContext context, AppLocalizations appLocalizations, String matchID, String groupName) {
    DocumentReference _reference = FirebaseFirestore.instance.collection('matches').doc(matchID);
    CoolAlert.show(
        context: context,
        type: CoolAlertType.confirm,
        animType: CoolAlertAnimType.slideInDown,
        title: appLocalizations.translate('are_you_sure'),
        cancelBtnText: appLocalizations.translate('cancel'),
        confirmBtnColor: Colors.green,
        cancelBtnTextStyle: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
        onConfirmBtnTap: () {
          _reference.delete();
          Navigator.pop(context);
        },
        text: appLocalizations.translate('cancel_match') + ' ' + groupName);
  }

  Widget content(AppLocalizations appLocalizations) {
    Query collectionReference = FirebaseFirestore.instance.collection('matches').orderBy("date");
    return StreamBuilder(
      stream: collectionReference.snapshots(),
      builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, int) {
                var data = snapshot.data.docs[int].data();
                String _matchID = snapshot.data.docs[int].id;
                Map<String, dynamic> loggedUsers = data['logged_players'];
                return Slidable(
                  actionPane: SlidableStrechActionPane(),
                  actionExtentRatio: 0.25,
                  secondaryActions: [
                    firebaseUser.uid == data['owner']
                        ? IconSlideAction(
                            caption: appLocalizations.translate('delete'),
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () => onPressDeleteMatchButton(
                                context, appLocalizations, _matchID, data['group_name']),
                          )
                        : Container(child: Icon(MdiIcons.trashCanOutline, color: Colors.grey)),
                  ],
                  child: ListTile(
                    tileColor: tileColor(data),
                    contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    onTap: () => onHockeyEventTap(context, data, _matchID),
                    title: Text(data['group_name'],
                        style: _defaultTextStyle(context).copyWith(fontSize: 18)),
                    trailing: Container(
                      width: 70,
                      alignment: Alignment.center,
                      child: Text(
                        loggedUsers.length.toString() + '/' + data['max_players'],
                        style: _defaultTextStyle(context).copyWith(fontSize: 20),
                      ),
                    ),
                    leading: data['sport_type'] == 'ice_hockey'
                        ? sportLogo(true, _matchID)
                        : sportLogo(false, _matchID),
                  ),
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
      endDrawer: chat(context, appLocalizations),
      appBar: appBar(context, appLocalizations),
      floatingActionButton: floatingActionButton(),
      body: content(appLocalizations),
    );
  }
}
