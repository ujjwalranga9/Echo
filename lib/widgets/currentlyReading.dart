import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../class/book.dart';
import 'libraryGrid.dart';
import 'libraryList.dart';
import 'libraryView.dart';
import '../main.dart';
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
      backgroundColor: Colors.black,
      body: SafeArea(
        child: (LibraryView.listView == false) ?  LibraryGrid(stateOfBook: 1,temp: temp,delete: onDelete,filter: bookFilter,update: stateChanged,) : LibraryList(temp: temp,delete: onDelete,filter: bookFilter,update: stateChanged,),

      ),
    );
  }
}
