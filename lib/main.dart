import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todolist/addtask.dart';
import 'package:localstore/localstore.dart';
import 'package:todolist/task.dart';

import 'Todo.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ToDoList(),
      )
  );
}

class ToDoList extends StatefulWidget {
  const ToDoList({Key? key}) : super(key: key);

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final _db = Localstore.instance;
  final _items = <String, Todo>{};
  StreamSubscription<Map<String, dynamic>>? _subscription;

  void initState() {
    _subscription = _db.collection('todos').stream.listen((event) {
      setState(() {
        final item = Todo.fromMap(event);
        _items.putIfAbsent(item.id, () => item);
      });
    });
    if (kIsWeb) _db.collection('todos').stream.asBroadcastStream();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: ListView.builder(
        itemCount: _items.keys.length,
        itemBuilder: (context, index) {
          final key = _items.keys.elementAt(index);
          final item = _items[key]!;
          debugPrint('title: ${item.title}');
          debugPrint('note: ${item.note}');

          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Task(item.title, item.note))
              );
            },
            child: Card(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            item.delete();
                            _items.remove(item.id);
                          });
                        },
                      ),
                      Text(item.title, style: TextStyle(fontSize: 16),),
                    ],
                  ),
                  Spacer(),
                  Checkbox(
                    value: item.done,
                    onChanged: (value) {
                      item.done = value!;
                      item.save();
                    },
                  )
                ]
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTask(_db))
          );
        },
        child: const Text('+', style: TextStyle(fontSize: 28))
      ),
    );
  }
}