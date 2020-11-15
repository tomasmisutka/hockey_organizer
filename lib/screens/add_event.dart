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
  bool _iceHockeyState = true;
  bool _inlineHockeyState = false;

  User get firebaseUser {
    return widget.firebaseUser;
  }

  @override
  void initState() {
    Player newPlayer = Player(firebaseUser.uid, firebaseUser.displayName);
    players = {"${newPlayer.name}": newPlayer.uid};
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
            calendarTitle: appLocalizations.translate('choose_time'),
            timeLabelText: appLocalizations.translate('time'),
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

  void onPressCreateButton(BuildContext context, AppLocalizations appLocalizations) async {
    if (validInformations(appLocalizations) == false) return;
    if (await validInternetConnection(appLocalizations) == false) return;
    var id = widget.databaseReference.child('HockeyEvents/').push();
    id.set(eventToJson());
    Navigator.of(context).pop();
  }

  Widget sportContainer(String imagePath, bool isActive) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(color: isActive == true ? Colors.red : Colors.transparent, width: 4),
          image: DecorationImage(
            // image: AssetImage('assets/ice_hockey_puck.png'),
            image: AssetImage(imagePath),
            fit: BoxFit.contain,
          )),
    );
  }

  Widget chooseSportWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        GestureDetector(
            onTap: () {
              setState(() {
                _sportType = 'ice_hockey';
                _iceHockeyState = true;
                _inlineHockeyState = false;
              });
            },
            child: sportContainer('assets/ice_hockey_puck.png', _iceHockeyState)),
        GestureDetector(
          onTap: () {
            setState(() {
              _sportType = 'inline_hockey';
              _iceHockeyState = false;
              _inlineHockeyState = true;
            });
          },
          child: sportContainer('assets/inline_hockey_ball.png', _inlineHockeyState),
        ),
      ],
    );
  }

  Widget content(BuildContext context, AppLocalizations appLocalizations) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 65),
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
                  appLocalizations.translate('sport') +
                      ': ' +
                      appLocalizations.translate(_sportType),
                  style: TextStyle(fontSize: 17)),
            ),
            const SizedBox(height: 25),
            chooseSportWidget(),
            const SizedBox(height: 25),
            ActionButton(
                buttonColor: Colors.blue,
                buttonText: appLocalizations.translate('create'),
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
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(appLocalizations.translate('add_new_event')),
        ),
        body: content(context, appLocalizations),
      ),
    );
  }
}

class Player {
  String uid;
  String name;

  Player(this.uid, this.name);
}
