import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';
import 'todo.dart';

class AddTask extends StatefulWidget {
  final Localstore db;
  const AddTask(this.db, {super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final name = TextEditingController();
  final note = TextEditingController();
  bool pin = false;
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
                pinned: pin,
              );
              item.save();
              Navigator.pop(context, false);
            } else if(name.text.isEmpty || note.text.isEmpty) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text('You did not fill out the form'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ));
            }
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  pin = !pin;
                });
              },
              icon: Icon(pin ? Icons.push_pin : Icons.push_pin_outlined)
          )
        ],
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
