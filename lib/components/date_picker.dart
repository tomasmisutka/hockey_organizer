import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:hockey_organizer/app_localization.dart';

class DatePicker extends StatefulWidget {
  final DateTime initialValue;
  final TextEditingController controller;

  DatePicker(this.controller, this.initialValue);

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  TextEditingController get controller => widget.controller;
  DateTime get initialValue => widget.initialValue;

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    controller.text = DateFormat('dd.MM.yyyy').format(initialValue);
    super.initState();
  }

  bool _decideWhichDayToEnable(DateTime day) {
    if ((day.isAfter(DateTime.now().subtract(Duration(days: 1))) &&
        day.isBefore(DateTime.now().add(Duration(days: 10))))) {
      return true;
    }
    return false;
  }

  Future<void> showDateOwnPicker(BuildContext context) async {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: initialValue,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      cancelText: appLocalizations.translate('cancel'),
      confirmText: appLocalizations.translate('confirm'),
      fieldLabelText: appLocalizations.translate('date'),
      helpText: appLocalizations.translate('choose_date'),
      selectableDayPredicate: _decideWhichDayToEnable,
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
        controller.text = DateFormat('dd.MM.yyyy').format(_selectedDate);
      });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations appLocalizations = AppLocalizations.of(context);
    return Row(
      children: [
        Icon(Icons.event, color: Colors.black, size: 25),
        const SizedBox(width: 15),
        Expanded(
          child: TextField(
              controller: controller,
              style: TextStyle(fontWeight: FontWeight.bold),
              textInputAction: TextInputAction.done,
              onTap: () => showDateOwnPicker(context),
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(width: 3, color: Theme.of(context).primaryColor)),
                labelText: appLocalizations.translate('date'),
              )),
        ),
      ],
    );
  }
}
