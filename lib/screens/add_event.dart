import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hockey_organizer/app_localization.dart';
import 'package:hockey_organizer/components/actionButton.dart';
import 'package:hockey_organizer/models/player.dart';

class AddEventScreen extends StatefulWidget {
  final User firebaseUser;
  // final DatabaseReference databaseReference;

  AddEventScreen(this.firebaseUser);

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
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
  List<String> players = [];
  bool _iceHockeyState = true;
  bool _inlineHockeyState = false;

  User get firebaseUser {
    return widget.firebaseUser;
  }

  @override
  void initState() {
    Player newPlayer = Player(firebaseUser.uid, firebaseUser.displayName);
    players.add(newPlayer.uid);
    super.initState();
  }

  Widget picker(AppLocalizations appLocalizations, Function(String) onChanged,
      {bool isDatePicker = true}) {
    Color iconColor = Colors.grey[300];
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
            // isDatePicker ? null : onChanged,
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

  Widget addEventTextField(TextEditingController controller, FocusNode node, String labelText,
      {IconData icon = Icons.description_outlined,
      TextInputType textInputType = TextInputType.name}) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[300]),
        const SizedBox(width: 15),
        Expanded(
          child: TextField(
            controller: controller,
            focusNode: node,
            textInputAction: TextInputAction.done,
            keyboardType: textInputType,
            decoration: InputDecoration(
                // labelText: appLocalizations.translate('gamers'),
                labelText: labelText),
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
    if (_placeController.text.trim() == '') {
      setState(() {
        _errorText = appLocalizations.translate('choose_place');
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

  Future<bool> validInternetConnection(AppLocalizations appLocalizations) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile)
      return true;
    else if (connectivityResult == ConnectivityResult.wifi) return true;
    setState(() {
      _errorText = appLocalizations.translate('no_internet_connection');
    });
    showInSnackBar(_errorText);
    return false;
  }

  Map<String, dynamic> addEvent() {
    editDateFormat(_date);
    return {
      'owner': firebaseUser.uid,
      'group_name': _groupController.text.trim().toUpperCase(),
      'date': _date,
      'time': _time,
      'place': _placeController.text.trim().toUpperCase(),
      'max_players': _playersController.text.trim(),
      'logged_players': players,
      'sport_type': _sportType,
    };
  }

  void onPressCreateButton(BuildContext context, AppLocalizations appLocalizations) async {
    if (validInputs(appLocalizations) == false) return;
    if (await validInternetConnection(appLocalizations) == false) return;
    CollectionReference collectionReference = FirebaseFirestore.instance.collection('events');
    collectionReference.add(addEvent()).whenComplete(() => Navigator.of(context).pop());
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
            child: sportView('assets/ice_hockey_puck.png', _iceHockeyState)),
        GestureDetector(
            onTap: () => onSportTap(false),
            child: sportView('assets/inline_hockey_ball.png', _inlineHockeyState)),
      ],
    );
  }

  Widget content(BuildContext context, AppLocalizations appLocalizations) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 50),
        child: Column(
          children: [
            addEventTextField(_groupController, _groupNode, appLocalizations.translate('group')),
            picker(appLocalizations, onChangedDatePicker),
            picker(appLocalizations, onChangedTimePicker, isDatePicker: false),
            addEventTextField(_placeController, _placeNode, appLocalizations.translate('place'),
                icon: Icons.place_outlined),
            addEventTextField(
                _playersController, _playersNode, appLocalizations.translate('gamers'),
                icon: Icons.people_outline, textInputType: TextInputType.number),
            const SizedBox(height: 25),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                  appLocalizations.translate('sport').toString() +
                      ': ' +
                      appLocalizations.translate(_sportType).toString(),
                  style: TextStyle(fontSize: 17)),
            ),
            const SizedBox(height: 25),
            sportOptions(),
            const SizedBox(height: 25),
            ActionButton(
                buttonColor: Colors.blue,
                buttonText: appLocalizations.translate('create').toString(),
                onPressed: () => onPressCreateButton(context, appLocalizations))
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
          title: Text(appLocalizations.translate('add_new_event'),
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: content(context, appLocalizations),
      ),
    );
  }
}
