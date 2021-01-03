import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../app_localization.dart';

class MatchDetail {
  String owner;
  String time;
  String date;
  Map<String, dynamic> loggedPlayers;
  String maxPlayers;
  String place;
  String groupName;
  String sportType;

  MatchDetail(
    this.owner,
    this.time,
    this.date,
    this.loggedPlayers,
    this.maxPlayers,
    this.place,
    this.groupName,
    this.sportType,
  );

  Widget getDateAndTime(BuildContext context, DocumentReference matchReference, TextStyle style) {
    return StreamBuilder(
        stream: matchReference.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();
          var matchDocument = snapshot.data;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(matchDocument['date'], style: style),
              Text(matchDocument['time'], style: style),
            ],
          );
        });
  }

  Widget getPlace(BuildContext context, DocumentReference matchReference, TextStyle style) {
    return StreamBuilder(
        stream: matchReference.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();
          var matchData = snapshot.data;
          return Text(matchData['place'], textAlign: TextAlign.center, style: style);
        });
  }

  Widget getCapacity(BuildContext context, DocumentReference matchReference, TextStyle style) {
    return StreamBuilder(
        stream: matchReference.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();
          var matchData = snapshot.data;
          return Text(
              matchData['logged_players'].length.toString() + '/' + matchData['max_players'],
              style: style);
        });
  }

  Widget getJoinOrLeaveButton(
      BuildContext context,
      AppLocalizations appLocalizations,
      DocumentReference matchReference,
      String uID,
      Function onJoinButtonPress,
      Function onLeaveButtonPress) {
    String textJoin = appLocalizations.translate('join');
    String textLeave = appLocalizations.translate('leave');
    return StreamBuilder(
        stream: matchReference.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();
          var matchData = snapshot.data;
          if (matchData['logged_players'].length.toString() == matchData['max_players'] &&
              !matchData['logged_players'].containsKey(uID)) return Container();
          return Align(
            alignment: Alignment.bottomRight,
            child: RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Text(
                  matchData['logged_players'].containsKey(uID) == true ? textLeave : textJoin,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              color:
                  matchData['logged_players'].containsKey(uID) == true ? Colors.red : Colors.green,
              padding: EdgeInsets.all(10),
              onPressed: matchData['logged_players'].containsKey(uID) == true
                  ? onLeaveButtonPress
                  : onJoinButtonPress,
            ),
          );
        });
  }
}
