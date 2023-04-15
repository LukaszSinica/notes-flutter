import 'package:localstore/localstore.dart';

class Todo {
  final String id;
  String title;
  String note;
  DateTime time;
  bool done;
  Todo({
    required this.id,
    required this.title,
    required this.note,
    required this.time,
    required this.done,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'time': time.millisecondsSinceEpoch,
      'done': done,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      title: map['title'],
      note: map['note'],
      time: DateTime.fromMicrosecondsSinceEpoch(map['time']),
      done: map['done'],
    );
  }
}

extension ExtTodo on Todo {
  Future save() async {
    final db = Localstore.instance;
    return db.collection('todos').doc(id).set(toMap());
  }

  Future delete() async {
    final db = Localstore.instance;
    return db.collection('todos').doc(id).delete();
  }
}