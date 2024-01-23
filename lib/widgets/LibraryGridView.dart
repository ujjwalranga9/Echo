import 'package:echo/bloc/book_state_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';

import '../bloc/localRepositoryBloc.dart';
import '../class/book.dart';
import '../main.dart';
import '../screens/bookDetails/book_details.dart';
import 'deleteDialog.dart';
import 'imageWidget.dart';

class LibraryGridView extends StatefulWidget {
  List<Book> books;
   LibraryGridView({required this.books,Key? key}) : super(key: key);

  @override
  State<LibraryGridView> createState() => _LibraryGridViewState();
}

class _LibraryGridViewState extends State<LibraryGridView> {
  @override
  Widget build(BuildContext context) {

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
              color: Theme.of(context).backgroundColor,
              height: MediaQuery.of(context).size.height*0.79,
              child: (widget.books.isNotEmpty) ? BlocBuilder<BookStateCubit,BookState>(
                builder: (context,state) {
                  return GridView.builder(
                        itemCount: widget.books.length,
                        gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 4/6,
                        ),
                        padding: const EdgeInsets.all(10),
                        itemBuilder: (ctx,index){
                          return   GestureDetector(

                              onLongPress: (){

                                // Hive.box<Book>('Lib').delete(searchBook[index].getBookName()+searchBook[index].id);
                                deleteDialog(book: widget.books[index], context: context).then((value) {
                                  // print(value);
                                  // if(value == true){
                                  //   widget.books.removeAt(index);
                                  //   widget.books.removeWhere((element) => element.getBookName() + element.id == widget.books[index].getBookName()+widget.books[index].id);
                                  //
                                  // }
                                  // setState(() {});
                                });
                                // setState(() {});
                              },

                              onTap: (){

                                Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                                  return BookDetails(book: widget.books[index],);
                                })).then((value) {
                                  setState(() {

                                  });
                                });

                                // Navigator.push(context, PageTransition(type: PageTransitionType.fade, child:  BookDetail(book: values[index],update: update),duration: Duration(milliseconds: 300)));


                              },
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Stack(
                                      alignment: Alignment.bottomRight,
                                      children: [
                                        ImageWidget(book: widget.books[index],width: 178.3,height: 265),
                                        // Container(width: 178.3,height: 265,decoration: BoxDecoration(border: Border.all(width: 0.5,color: Colors.black),borderRadius: BorderRadius.circular(10)),),

                                        if(timing)Padding(
                                          padding: const EdgeInsets.only(bottom: 1,right: 1),
                                          child: Container(
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                                              color: Colors.black54,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 5,right: 5,bottom: 2,top: 2),
                                              child: Container(
                                                  child: (widget.books[index].duration[0] != '0') ? Text(widget.books[index].bookLength().substring(0,widget.books[index].bookLength().length -7),style:
                                                  const TextStyle(color: Colors.white),) : const Text("")),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ],
                              )
                          );
                        } ,

                      );
                }
              ): const Center(child:
              Padding(
                padding: EdgeInsets.only(bottom: 80),
                child: Text("Nothing to Show here"),
              ),
              )
                 ),
              ),
          ]);

  }
}
