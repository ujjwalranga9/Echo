
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../class/book.dart';
import '../screens/bookDetails/widgets/imgWidget.dart';

Future<bool?> deleteDialog({required Book book, required BuildContext context}){
  return showDialog<bool>(context: context,builder: (ctx,){

    return AlertDialog(

      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
      ),backgroundColor: Colors.teal.shade50,

      title: const Center(child: Text("Are you Sure?")),
      content: SizedBox(

        height: 230,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            imageWid(const Size(250, 100), context, book),
            Center(
              child: Text(book.getBookName(), maxLines: 2,overflow: TextOverflow.ellipsis,style:
              const TextStyle(fontSize: 15,), textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,

      actions: [
        IconButton(
            onPressed: (){
              Navigator.of(context).pop(false);
              },
            icon: const Icon(Icons.close)),
        IconButton(
            onPressed: (){
              Hive.box<Book>('Lib').delete(book.getBookName()+book.id);
              Navigator.of(context).pop(true);},
            icon: const Icon(Icons.delete)),
      ],
    );
  });
}