import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

class Reminders extends StatefulWidget {
  const Reminders({Key? key}) : super(key: key);

  @override
  State<Reminders> createState() => _RemindersState();
}

class _RemindersState extends State<Reminders> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Notifications"),
      ),
      body: FutureBuilder(
        future: FlutterLocalNotificationsPlugin().pendingNotificationRequests(),
        builder: (context, item) {
          if(item.hasError) {
            debugPrint('error');
            return Center(child: Text('Loading'));
          }
          if(item.hasData) {
            List<PendingNotificationRequest>? notifications = item.data;
            return ListView.builder(
              itemCount: notifications?.length,
              itemBuilder: (context, position) {
                return Card(
                  child: Column(
                    children: [
                      Text('id: ${notifications?[position].id}'),
                      Text('payLoad: ${notifications?[position].payload}'),
                      Text('body: ${notifications?[position].body}'),
                    ],
                  )
                );
              },
            );
          }
          else {
            return Center(child: Text('Loading'));
          }
        }
      ),
    );
  }
}
