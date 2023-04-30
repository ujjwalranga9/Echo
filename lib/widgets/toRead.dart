import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../class/book.dart';
import 'libraryGrid.dart';
import 'libraryList.dart';
import 'libraryView.dart';

class ToRead extends StatefulWidget {
  ToRead({Key? key,}) : super(key: key);


  @override
  State<ToRead> createState() => _ToReadState();
}

class _ToReadState extends State<ToRead> {
  var box = Hive.box<Book>("Lib");
  var temp = Hive.box<Book>("toRead");

  void stateChanged(){
    setState(() {
    });
  }

  void bookFilter() async {
    await temp.clear();

      for(int i = 0 ; i < box.length ; i++) {
        if (box.getAt(i)!.duration[0] == '0') {

          temp.add(box.getAt(i)!);
        }else if(box.getAt(i)!.getPercentageListened() == "0%"){
          temp.add(box.getAt(i)!);
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
      backgroundColor: Colors.black ,
      body: SafeArea(
        child: (LibraryView.listView == false) ?  LibraryGrid(temp: temp,delete: onDelete,filter: bookFilter,update: stateChanged,) : LibraryList(temp: temp,delete: onDelete,filter: bookFilter,update: stateChanged,),

      ),
    );
  }
}
