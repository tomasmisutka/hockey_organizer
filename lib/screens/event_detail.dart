import 'package:flutter/material.dart';
import 'package:hockey_organizer/models/event_detail.dart';
import 'package:theme_provider/theme_provider.dart';

class HockeyEventDetail extends StatefulWidget {
  final EventDetail eventDetail;
  final String heroTag;

  HockeyEventDetail(this.eventDetail, this.heroTag);

  @override
  _HockeyEventDetailState createState() => _HockeyEventDetailState();
}

class _HockeyEventDetailState extends State<HockeyEventDetail> {
  EventDetail get eventDetail => widget.eventDetail;

  AppBar appBar(BuildContext context, TextStyle textStyle) {
    return AppBar(
      iconTheme: IconThemeData(
          color: ThemeProvider.themeOf(context).data.floatingActionButtonTheme.foregroundColor),
      title: Text(eventDetail.groupName, style: textStyle),
    );
  }

  Widget content(BuildContext context, TextStyle textStyle) {
    // AppLocalizations appLocalizations = AppLocalizations.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(eventDetail.date, style: textStyle.copyWith(fontSize: 20)),
                Text(eventDetail.time, style: textStyle.copyWith(fontSize: 20)),
              ],
            ),
          ),
          Expanded(
            child: Hero(
                tag: widget.heroTag,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: eventDetail.sportType == 'ice_hockey'
                              ? AssetImage('assets/hockey_puck.png')
                              : AssetImage('assets/hockey_ball.png'))),
                )),
          ),
          Text(
            eventDetail.place,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 35,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none),
          ),
          Spacer(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: ThemeProvider.themeOf(context).data.floatingActionButtonTheme.foregroundColor,
    );

    return Scaffold(
      appBar: appBar(context, _textStyle),
      body: content(context, _textStyle),
    );
  }
}
