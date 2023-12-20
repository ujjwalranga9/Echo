import 'package:echo/bloc/book_state_bloc.dart';
import 'package:echo/class/enum.dart';
import 'package:echo/repository/localdata.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../../bloc/bookListBloc.dart';
import '../../bloc/grid_list_cubit.dart';
import '../../class/book.dart';
import '../../widgets/LibraryGridView.dart';
import '../../widgets/libraryGrid.dart';
import '../../widgets/libraryList.dart';


class ViewBook extends StatefulWidget {

  final BookState bookState;
  const ViewBook({Key? key,required this.bookState}) : super(key: key);

  @override
  State<ViewBook> createState() => _ViewState();
}

class _ViewState extends State<ViewBook> {
  var box = Hive.box<Book>("Lib");
  late Box<Book> temp;

  @override
  void initState(){
    super.initState();

    if(widget.bookState is ToReadState){
       temp = Hive.box<Book>("toRead");
    }else if(widget.bookState is CurrentlyReadingState){
      temp = Hive.box<Book>("current");
    }else{
       temp = Hive.box<Book>("done");
    }

  }
  void stateChanged(){
    setState(() {
    });
  }

  void bookFilter() async {
    await temp.clear();

    if(widget.bookState is ToReadState){

      for(int i = 0 ; i < box.length ; i++) {

        if(box.getAt(i)!.status == 0){
          temp.add(box.getAt(i)!);
        }
      }

    }else if(widget.bookState is CurrentlyReadingState){

      for(int i = 0 ; i < box.length ; i++){
        if(box.getAt(i)!.status == 1){
          temp.add(box.getAt(i)!);
        }
      }

    }else{

      for(int i = 0 ; i < box.length ; i++){
        if(box.getAt(i)!.status == 2){
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
    print("sort Done");
  }
  void onDelete(String title){
    box.delete(title);
    setState((){});
  }

  @override
  Widget build(BuildContext context) {
    bookFilter();
    // sortByLen();

    return  Scaffold(
      backgroundColor: Colors.white ,

      body: BlocBuilder<GridListCubit,GridListState>(
          builder: (context,state) {
            return SafeArea(
              // child: (state is GridState)
              //     ?  LibraryGrid(stateOfBook: 0,temp: temp,delete: onDelete,update: stateChanged,)
              //     : LibraryList(temp: temp,delete: onDelete,filter: bookFilter,update: stateChanged,),

              child: (state is GridState)
                  ?  LibraryGridView(
                      books: (widget.bookState is ToReadState)
                          ? RepositoryProvider.of<LocalRepository>(context).getAllToReadBooks()
                          : (widget.bookState is CurrentlyReadingState)
                          ? RepositoryProvider.of<LocalRepository>(context).getAllCurrentlyReadingBooks()
                          : RepositoryProvider.of<LocalRepository>(context).getAllCompletedBooks(),
                    )
                  : LibraryList(temp: temp,delete: onDelete,filter: bookFilter,update: stateChanged,),

            );
          }
      ),
    );
  }
}
