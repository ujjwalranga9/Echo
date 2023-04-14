import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../class/book.dart';
import 'libraryGrid.dart';
import 'libraryList.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({Key? key}) : super(key: key);
  static bool listView = false;

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {

late int num =0;
final _textController = TextEditingController();
bool search = false;
@override
void initState(){
  super.initState();
  num = Hive.box<Book>('Lib').length;
}

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: (LibraryView.listView == false) ? const LibraryGrid() : const LibraryList(),

      ),
    );
  }
}
