

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../class/book.dart';

AlertDialog textUpdate(BuildContext context,Book book, String change,String previous){
  final _textController = TextEditingController(text: previous);

  return AlertDialog(
        title: Text(change),

        content: TextField(
          onSubmitted: (value) async {
            book.title = value;
            Hive.box<Book>("Lib").put(book.getBookName() + book.id, book);
          },

          style: const TextStyle(color: Colors.black),
          controller: _textController,
          autofocus: true,
          cursorColor: Colors.black,
          decoration: const InputDecoration(
            border: InputBorder.none,

          ),
        ),
        actions: [
          TextButton(onPressed: () {
            _textController.dispose();
            // Navigator.of(context).pop();
          }, child: Text("ok")),


          TextButton(onPressed: () {
            _textController.dispose();
            // Navigator.of(context).pop();
          }, child: Text("cencel")),
        ],

      );
}