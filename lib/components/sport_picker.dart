import 'package:flutter/material.dart';
import 'package:hockey_organizer/app_localization.dart';

class SportPicker extends StatefulWidget {
  const SportPicker({
    Key key,
  }) : super(key: key);

  @override
  SportPickerState createState() => SportPickerState();
}

class SportPickerState extends State<SportPicker> {
  bool _iceHockeyState = true;
  bool _inlineHockeyState = false;
  String type = 'ice_hockey';

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
        type = 'ice_hockey';
        _iceHockeyState = true;
        _inlineHockeyState = false;
      });
    } else {
      setState(() {
        type = 'inline_hockey';
        _iceHockeyState = false;
        _inlineHockeyState = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          child: Text(appLocalizations.translate('sport') + ': ' + appLocalizations.translate(type),
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
                onTap: () => onSportTap(true),
                child: sportView('assets/hockey_puck.png', _iceHockeyState)),
            GestureDetector(
                onTap: () => onSportTap(false),
                child: sportView('assets/hockey_ball.png', _inlineHockeyState)),
          ],
        ),
      ],
    );
  }
}
