import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hockey_organizer/components/action_button.dart';

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

  Widget getGroupName(BuildContext context, TextStyle style, String matchID) {
    DocumentReference _matchReference =
        FirebaseFirestore.instance.collection('matches').doc(matchID);
    return StreamBuilder(
        stream: _matchReference.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();
          var matchData = snapshot.data;
          return Text(matchData['group_name'], style: style);
        });
  }

  Widget getJoinOrLeaveButton(
      BuildContext context,
      AppLocalizations appLocalizations,
      DocumentReference matchReference,
      String uID,
      Function onJoinButtonPress,
      Function onLeaveButtonPress) {
    return StreamBuilder(
        stream: matchReference.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return CircularProgressIndicator();
          if (snapshot.hasError) print('problem with buttons'); //remove then
          var matchData = snapshot.data;
          if (matchData['logged_players'].length.toString() == matchData['max_players'] &&
              !matchData['logged_players'].containsKey(uID)) return Container();
          return Align(
            alignment: Alignment.bottomRight,
            child: ActionButton(
              buttonColor:
                  matchData['logged_players'].containsKey(uID) == true ? Colors.red : Colors.green,
              buttonText: matchData['logged_players'].containsKey(uID) == true ? 'leave' : 'join',
              onPressed: matchData['logged_players'].containsKey(uID) == true
                  ? onLeaveButtonPress
                  : onJoinButtonPress,
            ),
          );
        });
  }

  Future<void> updateData(Map<String, dynamic> updatedData, String matchID) async {
    DocumentReference _reference = FirebaseFirestore.instance.collection('matches').doc(matchID);
    await _reference.update(updatedData);
  }

  Future<DocumentSnapshot> getData(BuildContext context, String matchID) async {
    DocumentReference _reference = FirebaseFirestore.instance.collection('matches').doc(matchID);
    dynamic data = await _reference.get();
    return data;
  }
}
