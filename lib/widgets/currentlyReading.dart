import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../class/book.dart';
import 'libraryGrid.dart';
import 'libraryList.dart';
import 'libraryView.dart';

class CurrentRead extends StatefulWidget {
  const CurrentRead({Key? key,}) : super(key: key);


  @override
  State<CurrentRead> createState() => _CurrentReadState();
}

class _CurrentReadState extends State<CurrentRead> {
  var box = Hive.box<Book>("Lib");
  var temp = Hive.box<Book>("current");

  void stateChanged(){
    setState(() {
    });
  }

  void bookFilter() async {
    await temp.clear();
    for(int i = 0 ; i < box.length ; i++){
      if(box.getAt(i)!.duration[0] != '0') {

        if (box.getAt(i)!.getPercentageListened() != "0%" && box.getAt(i)!.getPercentageListened() != "100%") {
          temp.add(box.getAt(i)!);
        }
      }
    }

  }

  void onDelete(int index){
    var book = temp.getAt(index)!;
    box.delete(book.getBookName() + book.id);
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    bookFilter();

    return  Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: (LibraryView.listView == false) ?  LibraryGrid(temp: temp,delete: onDelete,filter: bookFilter,update: stateChanged,) : LibraryList(temp: temp,delete: onDelete,filter: bookFilter,update: stateChanged,),

      ),
    );
  }
}
