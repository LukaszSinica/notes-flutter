import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todolist/reminders.dart';
import 'package:todolist/todolist.dart';
import 'package:todolist/service/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  tz.initializeTimeZones();
  runApp(
      const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Home(),
      )
  );
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _index = 0;
  final screens = [
    ToDoList(),
    Reminders(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (value) {
          setState(() {
            _index = value;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.note_alt), label: 'Notes'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
        ],
      ),
    );
  }
}