import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../class/book.dart';
import 'libraryGrid.dart';
import 'libraryList.dart';
import 'libraryView.dart';
class DoneReading extends StatefulWidget {
  const DoneReading({Key? key,}) : super(key: key);


  @override
  State<DoneReading> createState() => _DoneReadingState();
}

class _DoneReadingState extends State<DoneReading> {
  var box = Hive.box<Book>("Lib");
  var temp = Hive.box<Book>("done");

  void stateChanged(){
    setState(() {
    });
  }

  void bookFilter() async {
    await temp.clear();
    for(int i = 0 ; i < box.length ; i++){
      if(box.getAt(i)!.duration[0] != '0') {
        if (box.getAt(i)!.getPercentageListened() == "100%") {
          temp.add(box.getAt(i)!);
        }
      }
    }
  }

  void sortByLen(){
    List<Book> values = temp.values.toList();
    values.sort((a,b)=> a.parseDuration(a.bookLength()).compareTo(b.parseDuration(b.bookLength())));

    for(int i = 0 ; i < values.length ; i++){
      temp.putAt(i,values[i]);
    }
  }

  void onDelete(String title){
    box.delete(title);
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    bookFilter();

    return  Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: (LibraryView.listView == false) ?  LibraryGrid(stateOfBook: 2,temp: temp,delete: onDelete,update: stateChanged,) : LibraryList(temp: temp,delete: onDelete,filter: bookFilter,update: stateChanged,),

      ),
    );
  }
}
