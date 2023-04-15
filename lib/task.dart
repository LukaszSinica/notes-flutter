import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class Task extends StatelessWidget {
  final String title;
  final String text;
  const Task(this.title, this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('Title: $title');
    debugPrint('Note: $text');

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Text(text)
    );
  }
}
