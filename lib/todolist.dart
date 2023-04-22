import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todolist/addtask.dart';
import 'package:localstore/localstore.dart';
import 'package:todolist/task.dart';
import 'todo.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({Key? key}) : super(key: key);

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final _db = Localstore.instance;
  final _itemsPinned = <String, Todo>{};
  final _itemsUnpinned = <String, Todo>{};
  StreamSubscription<Map<String, dynamic>>? _subscription;

  @override
  void initState() {
    _subscription = _db.collection('todos').stream.listen((event) {
      setState(() {
        final item = Todo.fromMap(event);
        if(item.pinned) {
          _itemsPinned.putIfAbsent(item.id, () => item);
        } else {
          _itemsUnpinned.putIfAbsent(item.id, () => item);
        }
      });
    });
    if (kIsWeb) _db.collection('todos').stream.asBroadcastStream();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _itemsPinned.keys.length,
              itemBuilder: (context, index) {
                final key = _itemsPinned.keys.elementAt(index);
                final item = _itemsPinned[key]!;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Task(item))
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
                                    _itemsPinned.remove(item.id);
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
          ),
          if(_itemsUnpinned.length > 0) Text('Unpinned'),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _itemsUnpinned.keys.length,
              itemBuilder: (context, index) {
                final key = _itemsUnpinned.keys.elementAt(index);
                final item = _itemsUnpinned[key]!;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Task(item))
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
                                    _itemsUnpinned.remove(item.id);
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
          ),
        ],
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
  @override
  void dispose() {
    if (_subscription != null) _subscription?.cancel();
    super.dispose();
  }
}