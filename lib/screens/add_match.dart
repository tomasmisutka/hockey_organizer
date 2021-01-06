import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hockey_organizer/app_localization.dart';
import 'package:hockey_organizer/components/action_button.dart';
import 'package:hockey_organizer/components/date_picker.dart';
import 'package:hockey_organizer/components/match_textfield.dart';
import 'package:hockey_organizer/components/sport_picker.dart';
import 'package:hockey_organizer/components/time_picker.dart';
import 'package:hockey_organizer/models/player.dart';

class AddMatch extends StatefulWidget {
  final User firebaseUser;

  AddMatch(this.firebaseUser);

  @override
  _AddMatchState createState() => _AddMatchState();
}

class _AddMatchState extends State<AddMatch> {
  GlobalKey<SportPickerState> _sportPickerGlobalKey = GlobalKey<SportPickerState>();
  String _errorText = '';
  TextEditingController _placeController = TextEditingController();
  TextEditingController _playersController = TextEditingController();
  TextEditingController _groupController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  FocusNode _placeNode = FocusNode();
  FocusNode _playersNode = FocusNode();
  FocusNode _groupNode = FocusNode();
  Map<String, dynamic> loggedPlayers = {};

  User get firebaseUser => widget.firebaseUser;

  @override
  void initState() {
    Player newPlayer = Player(firebaseUser.uid, firebaseUser.displayName);
    loggedPlayers[newPlayer.uid] = newPlayer.name;
    super.initState();
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
    return {
      'owner': firebaseUser.uid,
      'group_name': _groupController.text.trim().toUpperCase(),
      'date': _dateController.text.trim(),
      'time': _timeController.text.trim(),
      'place': _placeController.text.trim().toUpperCase(),
      'max_players': _playersController.text.trim(),
      'logged_players': loggedPlayers,
      'sport_type': _sportPickerGlobalKey.currentState.type,
    };
  }

  void onPressCreateButton(BuildContext context, AppLocalizations appLocalizations) async {
    if (validInputs(appLocalizations) == false) return;
    if (await checkInternetConnection(appLocalizations) == false) return;
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('matches');
    collectionReference.add(addMatch()).whenComplete(() => Navigator.of(context).pop());
  }

  SizedBox separatorHeight25() => const SizedBox(height: 25);

  Widget content(BuildContext context, AppLocalizations appLocalizations) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MatchTextField(_groupController, _groupNode, Icons.description_outlined, 'group',
                'enter_group_name'),
            DatePicker(_dateController, DateTime.now()),
            TimePicker(_timeController, TimeOfDay.now()),
            MatchTextField(
                _placeController, _placeNode, Icons.place_outlined, 'place', 'enter_place'),
            MatchTextField(_playersController, _playersNode, Icons.people_outline, 'max_players',
                'enter_players',
                inputType: TextInputType.number),
            separatorHeight25(),
            SportPicker(key: _sportPickerGlobalKey),
            separatorHeight25(),
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
