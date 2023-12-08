import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../class/book.dart';
import 'libraryGrid.dart';
import 'libraryList.dart';

class LibraryView extends StatefulWidget {
  LibraryView({required this.state,Key? key}) : super(key: key);
  static bool listView = false;
  int state;

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {

  var box = Hive.box<Book>("Lib");
  var temp = Hive.box<Book>("temp");

@override
void initState(){
  super.initState();

}
 void stateChanged(){
  setState(() {
  });
}

 void bookFilter(int state) async {
    await temp.clear();
  if(state == 1){
    for(int i = 0 ; i < box.length ; i++){
      if(box.getAt(i)!.duration[0] != '0') {

        if (box.getAt(i)!.getPercentageListened() != "0%" && box.getAt(i)!.getPercentageListened() != "100%") {
          temp.add(box.getAt(i)!);
        }
      }
    }

  }else if(state == 2){
    for(int i = 0 ; i < box.length ; i++){
      if(box.getAt(i)!.duration[0] != '0') {
        if (box.getAt(i)!.getPercentageListened() == "100%") {
          temp.add(box.getAt(i)!);
        }
      }
    }
  }else {
    for(int i = 0 ; i < box.length ; i++) {
      if (box.getAt(i)!.duration[0] == '0') {

          temp.add(box.getAt(i)!);
      }else if(box.getAt(i)!.getPercentageListened() == "0%"){
        temp.add(box.getAt(i)!);
      }
    }
  }

}

  void onDelete(String title){
    box.delete(title);
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
     bookFilter(widget.state);

    return  Scaffold(
          backgroundColor: Colors.transparent,

      // backgroundColor: (widget.state == 0) ? Colors.black : (widget.state == 1) ? Colors.white : Colors.blue,
      body: (LibraryView.listView == false) ?  LibraryGrid(stateOfBook: 0,temp: temp,delete: onDelete,update: stateChanged,)
                                            :  LibraryList(temp: temp,delete: onDelete,filter: bookFilter,update: stateChanged,),
    );
  }
}
