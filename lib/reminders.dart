import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Reminders extends StatefulWidget {
  const Reminders({Key? key}) : super(key: key);

  @override
  State<Reminders> createState() => _RemindersState();
}

class _RemindersState extends State<Reminders> {

  void showNotifications() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
    await FlutterLocalNotificationsPlugin().pendingNotificationRequests();
    pendingNotificationRequests.forEach((e) => {
    debugPrint('pending: ${e.body}')
    });
  }

  @override
  Widget build(BuildContext context) {
    showNotifications();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Notifications"),
      ),
    );
  }
}
