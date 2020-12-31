import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hockey_organizer/models/match_detail.dart';
import 'package:hockey_organizer/models/player.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

import '../app_localization.dart';

class MatchDetailScreen extends StatefulWidget {
  final MatchDetail matchDetail;
  final String matchID;

  MatchDetailScreen(this.matchDetail, this.matchID);

  @override
  _MatchDetailScreenState createState() => _MatchDetailScreenState();
}

class _MatchDetailScreenState extends State<MatchDetailScreen> {
  MatchDetail get matchDetail => widget.matchDetail;

  Color defaultColor(BuildContext context) =>
      ThemeProvider.themeOf(context).data.floatingActionButtonTheme.foregroundColor;

  AppBar appBar(BuildContext context, TextStyle textStyle) {
    return AppBar(
      iconTheme: IconThemeData(color: defaultColor(context)),
      title: Text(matchDetail.groupName, style: textStyle),
    );
  }

  bool showClearIconForOwner(BuildContext context, int index, Player player) {
    final firebaseUser = context.watch<User>();
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

    if (firebaseUser.uid == player.uid) personIconColor = Colors.lightBlue;
    return Icon(Icons.person, size: 30, color: personIconColor);
  }

  Future<void> updateData(String matchID, String playerUid) async {
    DocumentReference reference = FirebaseFirestore.instance.collection('matches').doc(matchID);
    matchDetail.loggedPlayers.remove(playerUid);
    await reference.update({'logged_players': matchDetail.loggedPlayers});
    setState(() {});
  }

  Widget clearIcon(BuildContext context, int index, Player player, String id) {
    return Visibility(
      child: IconButton(
        color: Colors.red,
        iconSize: 30,
        onPressed: () => updateData(id, player.uid),
        icon: Icon(Icons.clear),
      ),
      visible: showClearIconForOwner(context, index, player),
    );
  }

  Widget content(BuildContext context, TextStyle textStyle) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(matchDetail.date, style: textStyle.copyWith(fontSize: 20)),
                Text(matchDetail.time, style: textStyle.copyWith(fontSize: 20)),
              ],
            ),
          ),
          Expanded(
            child: Hero(
                tag: widget.matchID,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: matchDetail.sportType == 'ice_hockey'
                            ? AssetImage('assets/hockey_puck.png')
                            : AssetImage('assets/hockey_ball.png')),
                  ),
                )),
          ),
          Text(matchDetail.place,
              textAlign: TextAlign.center, style: textStyle.copyWith(fontSize: 35)),
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
                  Text(
                    matchDetail.loggedPlayers.length.toString() + '/' + matchDetail.maxPlayers,
                    style: textStyle.copyWith(fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          var _entryList = matchDetail.loggedPlayers.entries.toList();
                          Player _listPlayer =
                              Player(_entryList[index].key, _entryList[index].value);
                          return ListTile(
                            leading: listUserIcon(context, _listPlayer),
                            title: Text(_listPlayer.name, style: textStyle.copyWith(fontSize: 17)),
                            trailing: clearIcon(context, index, _listPlayer, widget.matchID),
                          );
                        },
                        itemCount: matchDetail.loggedPlayers.length,
                      ),
                    ),
                  ],
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
