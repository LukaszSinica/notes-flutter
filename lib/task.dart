import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:todolist/todo.dart';
import 'datepicker.dart';
import 'package:todolist/service/notification_service.dart';

class Task extends StatefulWidget {
  final Todo item;
  const Task(this.item, {Key? key}) : super(key: key);

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
                widget.item.save();
                Navigator.pushReplacementNamed(context, '/');
            },
            icon: Icon(Icons.arrow_back),
          ),
          title: Text(widget.item.title),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    widget.item.pinned = !widget.item.pinned;
                  });
                },
                icon: Icon(widget.item.pinned ? Icons.push_pin : Icons.push_pin_outlined)
            ),
            DatePickerTxt(scheduleNotification: () {
              debugPrint('Notification scheduled for $scheduleTime');
              NotificationService().scheduleNotification(
                  title: 'Scheduled Notification',
                  body: '$scheduleTime',
                  scheduledNotificationDateTime: scheduleTime
              );
            })
          ],
        ),
        body: Text(widget.item.note)
    );
  }
}

