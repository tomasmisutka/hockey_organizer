import 'package:connectivity/connectivity.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hockey_organizer/app_localization.dart';
import 'package:hockey_organizer/components/actionButton.dart';

class AddEventScreen extends StatefulWidget {
  final User firebaseUser;
  final DatabaseReference databaseReference;

  AddEventScreen(this.firebaseUser, this.databaseReference);

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
  Map<String, dynamic> players;

  User get firebaseUser {
    return widget.firebaseUser;
  }

  @override
  void initState() {
    Player newPlayer = Player(firebaseUser.uid, firebaseUser.displayName);
    players = {"${newPlayer.name}": newPlayer.uid};
    super.initState();
  }

  Widget _picker(AppLocalizations appLocalizations, Function(String) onChanged,
      {bool isDatePicker = true}) {
    return Container(
      constraints: BoxConstraints(maxWidth: 130),
      child: isDatePicker
          ? DateTimePicker(
              type: DateTimePickerType.date,
              dateMask: 'dd.MM.yyyy',
              calendarTitle: appLocalizations.translate('choose_date'),
              cancelText: appLocalizations.translate('cancel'),
              confirmText: appLocalizations.translate('confirm'),
              icon: Icon(Icons.event),
              firstDate: DateTime(DateTime.now().year),
              lastDate: DateTime(DateTime.now().year + 5),
              dateLabelText: appLocalizations.translate('date'),
              initialValue: _date,
              onChanged: isDatePicker ? onChanged : null,
            )
          : DateTimePicker(
              type: DateTimePickerType.time,
              icon: Icon(Icons.access_time),
              calendarTitle: appLocalizations.translate('choose_time'),
              timeLabelText: appLocalizations.translate('time'),
              initialValue: _time,
              onChanged: isDatePicker ? null : onChanged,
            ),
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

  Widget placeTextField(AppLocalizations appLocalizations) {
    return Row(
      children: [
        Icon(Icons.place_outlined, color: Colors.grey[600]),
        const SizedBox(width: 15),
        Container(
            constraints: BoxConstraints(maxWidth: 130),
            child: TextField(
              controller: _placeController,
              focusNode: _placeNode,
              decoration: InputDecoration(
                hintText: appLocalizations.translate('choose_place'),
                labelText: appLocalizations.translate('place'),
              ),
            )),
      ],
    );
  }

  Widget playersTextField(AppLocalizations appLocalizations) {
    return Row(
      children: [
        Icon(Icons.people, color: Colors.grey[600]),
        const SizedBox(width: 15),
        Container(
            constraints: BoxConstraints(maxWidth: 90),
            child: TextField(
              controller: _playersController,
              focusNode: _playersNode,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: appLocalizations.translate('gamers'),
              ),
            )),
      ],
    );
  }

  void unFocusTextFields() {
    _placeNode.unfocus();
    _playersNode.unfocus();
    _groupNode.unfocus();
  }

  SizedBox _separator20() => const SizedBox(height: 20);

  Widget dropDownHockeyItem(String imagePath) {
    return Container(
      width: 300,
      height: 75,
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(fit: BoxFit.cover, image: AssetImage('assets/$imagePath'))),
    );
  }

  Widget sportDropDownButton(AppLocalizations appLocalizations) {
    return Container(
      constraints: BoxConstraints(maxWidth: 300),
      child: DropdownButtonHideUnderline(
        child: DropdownButton(
          itemHeight: 75,
          value: _sportType,
          iconSize: 0,
          items: [
            DropdownMenuItem(value: 'ice_hockey', child: dropDownHockeyItem('ice_hockey.jpg')),
            DropdownMenuItem(
                value: 'inline_hockey', child: dropDownHockeyItem('inline_hockey.jpg')),
          ],
          onChanged: (sport) {
            setState(() {
              _sportType = sport;
            });
          },
        ),
      ),
    );
  }

  Widget _groupTextField(AppLocalizations appLocalizations) {
    return Container(
      constraints: BoxConstraints(maxWidth: 250),
      child: TextField(
        controller: _groupController,
        focusNode: _groupNode,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          hintText: appLocalizations.translate('name_of_group'),
          labelText: appLocalizations.translate('group'),
        ),
      ),
    );
  }

  void showInSnackBar(String description) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Text(
        description,
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

  bool validInformations(AppLocalizations appLocalizations) {
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

  Map<String, dynamic> eventToJson() {
    editDateFormat(_date);
    return {
      'Owner': firebaseUser.displayName,
      'Group': _groupController.text.trim(),
      'Date': _date,
      'Time': _time,
      'Place': _placeController.text.trim(),
      'MaxPlayers': _playersController.text.trim(),
      'Players': players,
      'SportType': _sportType,
    };
  }

  Widget _content(BuildContext context, AppLocalizations appLocalizations) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            _separator20(),
            _groupTextField(appLocalizations),
            _separator20(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _picker(appLocalizations, onChangedDatePicker),
                _picker(appLocalizations, onChangedTimePicker, isDatePicker: false),
              ],
            ),
            _separator20(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                placeTextField(appLocalizations),
                playersTextField(appLocalizations),
              ],
            ),
            _separator20(),
            Container(
              constraints: BoxConstraints(maxWidth: 300),
              alignment: Alignment.centerLeft,
              child: Text(
                  appLocalizations.translate('choose_sport') +
                      ': ' +
                      appLocalizations.translate(_sportType),
                  style: TextStyle(fontSize: 17)),
            ),
            _separator20(),
            sportDropDownButton(appLocalizations),
            _separator20(),
            _separator20(),
            ActionButton(
              buttonColor: Colors.blue,
              buttonText: appLocalizations.translate('create'),
              onPressed: () async {
                if (validInformations(appLocalizations) == false) return;
                if (await validInternetConnection(appLocalizations) == false) return;
                var id = widget.databaseReference.child('HockeyEvents/').push();
                id.set(eventToJson());
                Navigator.of(context).pop();
              },
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
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(appLocalizations.translate('add_new_event')),
        ),
        body: _content(context, appLocalizations),
      ),
    );
  }
}

class Player {
  String uid;
  String name;

  Player(this.uid, this.name);
}
