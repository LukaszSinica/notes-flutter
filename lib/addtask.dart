import 'dart:async';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';

import 'Todo.dart';

class AddTask extends StatefulWidget {
  final Localstore db;
  const AddTask(this.db, {super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final name = TextEditingController();
  final note = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {
            if(name.text.isNotEmpty && note.text.isNotEmpty) {
              final id = Localstore.instance
                  .collection('todos')
                  .doc()
                  .id;
              final now = DateTime.now();
              final item = Todo(
                id: id,
                title: name.text,
                note: note.text,
                time: now,
                done: false,
              );
              item.save();
            }
            Navigator.pop(context, false);
          },
          icon: Icon(Icons.arrow_back),
        )
      ),
      body: Column(
        children: [
          TextField(
            controller: name,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Name',
            ),
          ),
          Flexible(
            child: TextField(
              controller: note,
              maxLines: null,
              expands: true,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                  filled: true,
                  hintText: 'Enter a message'
              ),
            ),
          )
        ],
      ),
    );
  }
}
