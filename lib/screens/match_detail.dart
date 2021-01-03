import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hockey_organizer/components/action_button.dart';
import 'package:hockey_organizer/models/match_detail.dart';
import 'package:hockey_organizer/models/player.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

import '../app_localization.dart';

class MatchDetailScreen extends StatefulWidget {
  final MatchDetail matchDetail;
  final String matchID;
  final User firebaseUser;

  MatchDetailScreen(this.matchDetail, this.matchID, this.firebaseUser);

  @override
  _MatchDetailScreenState createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> {
  MatchDetail get matchDetail => widget.matchDetail;
  User get firebaseUser => widget.firebaseUser;
  String get matchID => widget.matchID;

  Color defaultColor(BuildContext context) =>
      ThemeProvider.themeOf(context).data.floatingActionButtonTheme.foregroundColor;

  AppBar appBar(BuildContext context, TextStyle textStyle) {
    return AppBar(
      iconTheme: IconThemeData(color: defaultColor(context)),
      title: matchDetail.getGroupName(context, textStyle, matchID),
    );
  }

  bool showClearIconForOwner(int index, Player player) {
    if (firebaseUser.uid == matchDetail.owner) {
      if (player.uid == matchDetail.owner) return false;
      return true;
    }
    return false;
  }

  Icon listUserIcon(BuildContext context, Player player) {
    final firebaseUser = context.watch<User>();
    Color personIconColor = Colors.black;
    if (player.uid == matchDetail.owner) {
      if (firebaseUser.uid == player.uid) return Icon(MdiIcons.crown, size: 30, color: Colors.red);

      return Icon(MdiIcons.crown, size: 30, color: Color(0xffFFD700));
    }

    if (firebaseUser.uid == player.uid) personIconColor = Colors.red;
    return Icon(Icons.person, size: 30, color: personIconColor);
  }

  void showAlert(BuildContext context, Player player) {
    AppLocalizations _appLocalizations = AppLocalizations.of(context);
    CoolAlert.show(
        context: context,
        type: CoolAlertType.confirm,
        animType: CoolAlertAnimType.slideInDown,
        title: _appLocalizations.translate('are_you_sure'),
        cancelBtnText: _appLocalizations.translate('cancel'),
        confirmBtnColor: Colors.green,
        cancelBtnTextStyle: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
        onConfirmBtnTap: () {
          matchDetail.loggedPlayers.remove(player.uid);
          matchDetail.updateData({'logged_players': matchDetail.loggedPlayers}, matchID);
          Navigator.pop(context);
        },
        text: _appLocalizations.translate('remove') + ' ' + player.name);
  }

  Widget clearIcon(BuildContext context, int index, Player player) {
    return Visibility(
      child: IconButton(
        color: Colors.red,
        iconSize: 30,
        onPressed: () => showAlert(context, player),
        icon: Icon(Icons.clear),
      ),
      visible: showClearIconForOwner(index, player),
    );
  }

  Widget editIcon(BuildContext context, AppLocalizations appLocalizations) {
    return Visibility(
      child: Align(
          child: ActionButton(
            onPressed: () => onPressEditIcon(context, appLocalizations),
            buttonColor: Colors.orangeAccent,
            buttonText: 'edit',
          ),
          alignment: Alignment.bottomLeft),
      visible: firebaseUser.uid == matchDetail.owner ? true : false,
    );
  }

  AlertDialog alertDialog(AppLocalizations appLocalizations, DocumentSnapshot data) {
    // String _date;
    // String _time = data['time'];
    TextEditingController _groupController = TextEditingController();
    TextEditingController _placeController = TextEditingController();
    TextEditingController _maxPlayersController = TextEditingController();
    _groupController.text = data['group_name'];
    _placeController.text = data['place'];
    _maxPlayersController.text = data['max_players'];
    TextStyle contentStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
    return AlertDialog(
      title: Container(
          alignment: Alignment.center, child: Text(appLocalizations.translate('edit_match'))),
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextField(
            controller: _groupController,
            style: contentStyle,
          ),
          // TimePicker(appLocalizations, onChangedDatePicker, _date, true),
          // TimePicker(appLocalizations, onChangedTimePicker, _time),
          TextField(
            controller: _placeController,
            style: contentStyle,
          ),
          TextField(
            controller: _maxPlayersController,
            style: contentStyle,
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      contentPadding: EdgeInsets.all(10),
      actions: [
        ActionButton(
            onPressed: () {
              matchDetail.updateData({
                "group_name": _groupController.text.trim().toUpperCase(),
                "place": _placeController.text.trim().toUpperCase(),
                "max_players": _maxPlayersController.text.trim(),
              }, matchID);
              Navigator.pop(context);
            },
            buttonColor: Colors.orangeAccent,
            buttonText: 'save_edits'),
        ActionButton(
            buttonText: 'cancel', buttonColor: Colors.red, onPressed: () => Navigator.pop(context))
      ],
    );
  }

  void onPressEditIcon(BuildContext context, AppLocalizations appLocalizations) async {
    DocumentSnapshot data = await matchDetail.getData(context, matchID);
    showDialog(context: context, builder: (_) => alertDialog(appLocalizations, data));
  }

  void onPressCancelMatch(BuildContext context, AppLocalizations appLocalizations) {
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
          Navigator.pop(context);
        },
        text: appLocalizations.translate('cancel_match') + ' ' + matchDetail.groupName);
  }

  Widget deleteMatchButton(BuildContext context, AppLocalizations appLocalizations) {
    return Align(
      alignment: Alignment.bottomRight,
      child: ActionButton(
          onPressed: () => onPressCancelMatch(context, appLocalizations),
          buttonText: 'cancel_match',
          buttonColor: Colors.red),
    );
  }

  void onPressJoinButton() {
    matchDetail.loggedPlayers[firebaseUser.uid] = firebaseUser.displayName;
    matchDetail.updateData({'logged_players': matchDetail.loggedPlayers}, matchID);
  }

  void onPressLeaveButton() {
    matchDetail.loggedPlayers.remove(firebaseUser.uid);
    matchDetail.updateData({'logged_players': matchDetail.loggedPlayers}, matchID);
  }

  Widget statusButton(
      BuildContext context, AppLocalizations appLocalizations, DocumentReference reference) {
    if (firebaseUser.uid == matchDetail.owner) return deleteMatchButton(context, appLocalizations);
    return matchDetail.getJoinOrLeaveButton(context, appLocalizations, reference, firebaseUser.uid,
        onPressJoinButton, onPressLeaveButton);
  }

  Widget content(BuildContext context, TextStyle textStyle) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    DocumentReference matchReference =
        FirebaseFirestore.instance.collection('matches').doc(matchID);
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          matchDetail.getDateAndTime(context, matchReference, textStyle.copyWith(fontSize: 20)),
          Expanded(
            child: Stack(
              children: [
                Hero(
                  tag: matchID,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: matchDetail.sportType == 'ice_hockey'
                              ? AssetImage('assets/hockey_puck.png')
                              : AssetImage('assets/hockey_ball.png')),
                    ),
                  ),
                ),
                editIcon(context, appLocalizations),
                statusButton(context, appLocalizations, matchReference),
              ],
            ),
          ),
          matchDetail.getPlace(context, matchReference, textStyle.copyWith(fontSize: 35)),
          const SizedBox(height: 15),
          Expanded(
              child: Column(
            children: [
              Row(
                children: [
                  Text(
                    appLocalizations.translate('gamers') + ':',
                    style: textStyle.copyWith(fontSize: 20),
                  ),
                  const SizedBox(width: 5),
                  Icon(Icons.arrow_downward, size: 25, color: defaultColor(context)),
                  Spacer(),
                  matchDetail.getCapacity(context, matchReference, textStyle.copyWith(fontSize: 20))
                ],
              ),
              const SizedBox(height: 15),
              Expanded(
                child: StreamBuilder(
                  stream: matchReference.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return CircularProgressIndicator();
                    var matchDocument = snapshot.data;
                    matchDetail.loggedPlayers = matchDocument['logged_players'];
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        var _entryList = matchDetail.loggedPlayers.entries.toList();
                        Player _listPlayer = Player(_entryList[index].key, _entryList[index].value);
                        return ListTile(
                          leading: listUserIcon(context, _listPlayer),
                          title: Text(_listPlayer.name, style: textStyle.copyWith(fontSize: 17)),
                          trailing: clearIcon(context, index, _listPlayer),
                        );
                      },
                      itemCount: matchDocument['logged_players'].length,
                    );
                  },
                ),
              ),
            ],
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: defaultColor(context),
    );
    return Scaffold(
      appBar: appBar(context, _textStyle),
      body: content(context, _textStyle),
    );
  }
}
