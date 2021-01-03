import 'package:flutter/material.dart';
import 'package:hockey_organizer/app_localization.dart';

class TimePicker extends StatefulWidget {
  final TimeOfDay initialValue;
  final TextEditingController controller;

  TimePicker(this.controller, this.initialValue);

  @override
  _TimePickerState createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  TextEditingController get controller => widget.controller;
  TimeOfDay get initialValue => widget.initialValue;
  TimeOfDay _selectedTime;

  @override
  void initState() {
    _selectedTime = initialValue;
    controller.text = _selectedTime.hour.toString() + ":" + _adjustMinutes(_selectedTime.minute);
    super.initState();
  }

  String _adjustMinutes(int minutes) {
    if (minutes > 9) return _selectedTime.minute.toString();
    if (minutes == 0) return '00';
    return '0' + _selectedTime.minute.toString();
  }

  Future<void> _selectTime(BuildContext context) async {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      confirmText: appLocalizations.translate('confirm'),
      cancelText: appLocalizations.translate('cancel'),
      helpText: appLocalizations.translate('choose_time'),
    );
    if (picked != null)
      setState(() {
        _selectedTime = picked;
        controller.text =
            _selectedTime.hour.toString() + ":" + _adjustMinutes(_selectedTime.minute);
      });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    return Row(
      children: [
        Icon(Icons.access_time, color: Colors.black, size: 25),
        const SizedBox(width: 15),
        Expanded(
          child: TextField(
              controller: controller,
              style: TextStyle(fontWeight: FontWeight.bold),
              textInputAction: TextInputAction.done,
              onTap: () => _selectTime(context),
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Theme.of(context).primaryColor)),
                labelText: appLocalizations.translate('time'),
              )),
        ),
      ],
    );
  }
}
