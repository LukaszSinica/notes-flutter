import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:todolist/service/notification_service.dart';
import 'package:todolist/task.dart';

class DatePickerTxt extends StatefulWidget {
  final Function() scheduleNotification;
  const DatePickerTxt({super.key, required this.scheduleNotification});

  @override
  State<DatePickerTxt> createState() => _DatePickerTxtState();
}

class _DatePickerTxtState extends State<DatePickerTxt> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        DatePicker.showDateTimePicker(
          context,
          showTitleActions: true,
          onChanged: (date) => scheduleTime = date,
          onConfirm: (date) => widget.scheduleNotification(),
        );
      },
      icon: Icon(Icons.date_range),
    );
  }
}

