import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:localstore/localstore.dart';
import 'package:todolist/service/notification_service.dart';
import 'package:todolist/todo.dart';

class Reminders extends StatefulWidget {
  const Reminders({Key? key}) : super(key: key);

  @override
  State<Reminders> createState() => _RemindersState();
}

class _RemindersState extends State<Reminders> {
  final db = Localstore.instance;

  @override
  Widget build(BuildContext context) {
    NotificationService notification = NotificationService();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Notifications"),
      ),
      body: StreamBuilder(
        stream: FlutterLocalNotificationsPlugin().pendingNotificationRequests().asStream(),
        builder: (context, item) {
          if(item.hasError) {
            return Center(child: Text('Loading'));
          }
          if(item.hasData) {
            List<PendingNotificationRequest>? notifications = item.data;
            bool visibilityController = true;
            return ListView.builder(
              itemCount: notifications?.length,
              itemBuilder: (context, position) {
                return Visibility(
                  visible: visibilityController,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                notifications?[position].title as String, style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),),
                              Text(
                                notifications?[position].body as String,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                softWrap: false,
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              notification.cancelNotification(notifications?[position].id).then((value) =>
                                  setState(() {
                                    visibilityController = false;
                                  })
                              );
                            },
                            child: Icon(Icons.highlight_remove, color: Colors.black,),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.black,
                              shadowColor: Colors.transparent,
                            ),
                          )
                        ],
                      ),
                    )
                  ),
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
