import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hockey_organizer/app_localization.dart';
import 'package:hockey_organizer/components/actionButton.dart';
import 'package:hockey_organizer/models/player.dart';

class AddMatch extends StatefulWidget {
  final User firebaseUser;

  AddMatch(this.firebaseUser);

  @override
  _AddMatchState createState() => _AddMatchState();
}

class _AddMatchState extends State<AddMatch> {
  String _date = DateTime.now().toString().substring(0, 10).trim();
  String _time = DateFormat('kk:mm').format(DateTime.now());
  String _errorText = '';
  String _sportType = 'ice_hockey';
  TextEditingController _placeController = TextEditingController();
  TextEditingController _playersController = TextEditingController();
  TextEditingController _groupController = TextEditingController();
  FocusNode _placeNode = FocusNode();
  FocusNode _playersNode = FocusNode();
  FocusNode _groupNode = FocusNode();
  Map<String, dynamic> loggedPlayers = {};
  bool _iceHockeyState = true;
  bool _inlineHockeyState = false;

  User get firebaseUser {
    return widget.firebaseUser;
  }

  @override
  void initState() {
    Player newPlayer = Player(firebaseUser.uid, firebaseUser.displayName);
    loggedPlayers[newPlayer.uid] = newPlayer.name;
    super.initState();
  }

  Widget picker(AppLocalizations appLocalizations, Function(String) onChanged,
      {bool isDatePicker = true}) {
    Color iconColor = Colors.black;
    return isDatePicker
        ? DateTimePicker(
            type: DateTimePickerType.date,
            dateMask: 'dd.MM.yyyy',
            calendarTitle: appLocalizations.translate('choose_date'),
            cancelText: appLocalizations.translate('cancel'),
            confirmText: appLocalizations.translate('confirm'),
            icon: Icon(Icons.event, color: iconColor),
            firstDate: DateTime(DateTime.now().year),
            lastDate: DateTime(DateTime.now().year + 5),
            dateLabelText: appLocalizations.translate('date'),
            initialValue: _date,
            onChanged: isDatePicker ? onChanged : null,
          )
        : DateTimePicker(
            type: DateTimePickerType.time,
            icon: Icon(Icons.access_time, color: iconColor),
            calendarTitle: appLocalizations.translate('choose_time').toString(),
            timeLabelText: appLocalizations.translate('time').toString(),
            initialValue: _time,
            onChanged: isDatePicker ? null : onChanged,
          );
  }

  void editDateFormat(String date) {
    List<String> parsedDate = date.split('-');
    String year = parsedDate[0];
    String month = parsedDate[1];
    String day = parsedDate[2];
    _date = day + '.' + month + '.' + year;
  }

  void onChangedDatePicker(newDate) => _date = newDate;
  void onChangedTimePicker(newTime) => _time = newTime;

  Widget newMatchTextField(TextEditingController controller, FocusNode node, String labelText,
      {IconData icon = Icons.description_outlined,
      TextInputType textInputType = TextInputType.name}) {
    return Row(
      children: [
        Icon(icon, color: Colors.black),
        const SizedBox(width: 15),
        Expanded(
          child: TextField(
            controller: controller,
            focusNode: node,
            style: TextStyle(fontWeight: FontWeight.bold),
            textInputAction: TextInputAction.done,
            keyboardType: textInputType,
            decoration: InputDecoration(labelText: labelText),
          ),
        ),
      ],
    );
  }

  void unFocusTextFields() {
    _placeNode.unfocus();
    _playersNode.unfocus();
    _groupNode.unfocus();
  }

  void showInSnackBar(String description) {
    FocusScope.of(context).requestFocus(new FocusNode());
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: Text(
        description.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
      ),
      padding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
      backgroundColor: Color(0xfff32013),
      duration: Duration(seconds: 3),
    ));
  }

  bool validInputs(AppLocalizations appLocalizations) {
    if (_groupController.text.trim() == '') {
      setState(() {
        _errorText = appLocalizations.translate('enter_group_name');
      });
      showInSnackBar(_errorText);
      return false;
    }
    if (_groupController.text.trim().length > 15) {
      setState(() {
        _errorText = appLocalizations.translate('too_long_name');
      });
      showInSnackBar(_errorText);
      return false;
    }
    if (_placeController.text.trim() == '') {
      setState(() {
        _errorText = appLocalizations.translate('choose_place');
      });
      showInSnackBar(_errorText);
      return false;
    }
    if (_placeController.text.trim().length > 20) {
      setState(() {
        _errorText = appLocalizations.translate('too_long_name');
      });
      showInSnackBar(_errorText);
      return false;
    }
    if (_playersController.text.trim() == '') {
      setState(() {
        _errorText = appLocalizations.translate('enter_players');
      });
      showInSnackBar(_errorText);
      return false;
    }
    return true;
  }

  Future<bool> checkInternetConnection(AppLocalizations appLocalizations) async {
    try {
      final internetAccess = await InternetAddress.lookup('google.com');
      if (internetAccess.isNotEmpty && internetAccess[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (e) {
      print(e.message);
      setState(() {
        _errorText = appLocalizations.translate('no_internet_connection');
      });
    }
    showInSnackBar(_errorText);
    return false;
  }

  Map<String, dynamic> addMatch() {
    editDateFormat(_date);
    return {
      'owner': firebaseUser.uid,
      'group_name': _groupController.text.trim().toUpperCase(),
      'date': _date,
      'time': _time,
      'place': _placeController.text.trim().toUpperCase(),
      'max_players': _playersController.text.trim(),
      'logged_players': loggedPlayers,
      'sport_type': _sportType,
    };
  }

  void onPressCreateButton(BuildContext context, AppLocalizations appLocalizations) async {
    if (validInputs(appLocalizations) == false) return;
    if (await checkInternetConnection(appLocalizations) == false) return;
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('matches');
    collectionReference.add(addMatch()).whenComplete(() => Navigator.of(context).pop());
  }

  Widget sportView(String imagePath, bool isActive) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isActive == true ? Colors.red : Colors.transparent, width: 4),
          image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.contain)),
    );
  }

  void onSportTap(bool isIceHockey) {
    if (isIceHockey == true) {
      setState(() {
        _sportType = 'ice_hockey';
        _iceHockeyState = true;
        _inlineHockeyState = false;
      });
    } else {
      setState(() {
        _sportType = 'inline_hockey';
        _iceHockeyState = false;
        _inlineHockeyState = true;
      });
    }
  }

  Widget sportOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
            onTap: () => onSportTap(true),
            child: sportView('assets/hockey_puck.png', _iceHockeyState)),
        GestureDetector(
            onTap: () => onSportTap(false),
            child: sportView('assets/hockey_ball.png', _inlineHockeyState)),
      ],
    );
  }

  Widget content(BuildContext context, AppLocalizations appLocalizations) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 50),
        child: Column(
          children: [
            newMatchTextField(_groupController, _groupNode, appLocalizations.translate('group')),
            picker(appLocalizations, onChangedDatePicker),
            picker(appLocalizations, onChangedTimePicker, isDatePicker: false),
            newMatchTextField(_placeController, _placeNode, appLocalizations.translate('place'),
                icon: Icons.place_outlined),
            newMatchTextField(
                _playersController, _playersNode, appLocalizations.translate('max_players'),
                icon: Icons.people_outline, textInputType: TextInputType.number),
            const SizedBox(height: 25),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                  appLocalizations.translate('sport') +
                      ': ' +
                      appLocalizations.translate(_sportType),
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 25),
            sportOptions(),
            const SizedBox(height: 25),
            ActionButton(
              buttonColor: Colors.blue,
              buttonText: 'create',
              onPressed: () => onPressCreateButton(context, appLocalizations),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () => unFocusTextFields(),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
          ),
          title: Text(appLocalizations.translate('new_match'),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).floatingActionButtonTheme.foregroundColor,
              )),
        ),
        body: content(context, appLocalizations),
      ),
    );
  }
}
