import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hockey_organizer/models/event_detail.dart';
import 'package:provider/provider.dart';
import 'package:theme_provider/theme_provider.dart';

import '../app_localization.dart';

class HockeyEventDetail extends StatefulWidget {
  final EventDetail eventDetail;
  final String heroAnimationTag;

  HockeyEventDetail(this.eventDetail, this.heroAnimationTag);

  @override
  _HockeyEventDetailState createState() => _HockeyEventDetailState();
}

class _HockeyEventDetailState extends State<HockeyEventDetail> {
  EventDetail get _eventDetail => widget.eventDetail;

  // @override
  // void initState() {
  //   super.initState();
  //   _getData();
  // }
  //
  // void _getData() {
  //   FirebaseFirestore.instance
  //       .collection('events')
  //       .doc(widget.heroAnimationTag)
  //       .get()
  //       .then((DocumentSnapshot snapshot) {
  //     setState(() {
  //       _eventDetail = EventDetail(
  //           snapshot['owner'],
  //           snapshot['time'],
  //           snapshot['date'],
  //           snapshot['logged_players'],
  //           snapshot['max_players'],
  //           snapshot['place'],
  //           snapshot['group_name'],
  //           snapshot['sport_type']);
  //     });
  //   });
  // }

  Color defaultColor(BuildContext context) =>
      ThemeProvider.themeOf(context).data.floatingActionButtonTheme.foregroundColor;

  AppBar appBar(BuildContext context, TextStyle textStyle) {
    return AppBar(
      iconTheme: IconThemeData(color: defaultColor(context)),
      title: Text(_eventDetail.groupName, style: textStyle),
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
                Text(_eventDetail.date, style: textStyle.copyWith(fontSize: 20)),
                Text(_eventDetail.time, style: textStyle.copyWith(fontSize: 20)),
              ],
            ),
          ),
          Expanded(
            child: Hero(
                tag: widget.heroAnimationTag,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: _eventDetail.sportType == 'ice_hockey'
                            ? AssetImage('assets/hockey_puck.png')
                            : AssetImage('assets/hockey_ball.png')),
                  ),
                )),
          ),
          Text(
            _eventDetail.place,
            textAlign: TextAlign.center,
            style: textStyle.copyWith(fontSize: 35),
          ),
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
                ],
              ),
              const SizedBox(height: 15),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              _eventDetail.loggedPlayers[index] != _eventDetail.owner
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                      child: Icon(Icons.person, size: 30),
                                    )
                                  : Image.asset('assets/crown.png', width: 40, height: 40),
                              const SizedBox(width: 5),
                              Text(_eventDetail.loggedPlayers[index]),
                              Spacer(),
                              Visibility(
                                child: IconButton(
                                  color: Colors.red,
                                  iconSize: 30,
                                  onPressed: () {},
                                  icon: Icon(Icons.clear),
                                ),
                                visible: showClearIcon(context, index),
                              ),
                            ],
                          );
                        },
                        itemCount: _eventDetail.loggedPlayers.length,
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

  bool showClearIcon(BuildContext context, int index) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser.uid == _eventDetail.owner) {
      if (_eventDetail.loggedPlayers[index] == _eventDetail.owner) return false;
      return true;
    }
    return false;
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
