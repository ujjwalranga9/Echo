import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:page_transition/page_transition.dart';

import '../class/book.dart';
import '../screens/bookDetails/book_details.dart';
import 'bookDetail.dart';
import 'imageWidget.dart';

class LibraryList extends StatefulWidget {
  LibraryList({Key? key,required this.update,required this.delete,required this.temp,required this.filter,}) : super(key: key);


  Function filter;
  Function delete;
  Function update;
  Box<Book> temp;

  @override
  State<LibraryList> createState() => _LibraryListState();
}

class _LibraryListState extends State<LibraryList> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [

        SliverToBoxAdapter(
          child: SizedBox(
              height: MediaQuery.of(context).size.height*0.89,
              child: ValueListenableBuilder(
                valueListenable: widget.temp.listenable(),
                builder: (context , Box<Book>box,_){
                  return ListView.builder(
                      itemCount: box.length,
                      itemBuilder: (ctx,index){
                        final bok = box.getAt(index);
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: GestureDetector(
                            onTap: (){

                                      Navigator.push(
                                            context,
                                            PageTransition(
                                                type: PageTransitionType.fade,
                                                child:  BookDetails(book: bok!),
                                                duration: const Duration(milliseconds: 300)
                                            )
                                        );

                            },

                            child: Container(
                              height: 140,
                              decoration: BoxDecoration(
                                  borderRadius:BorderRadius.circular(20),
                                  color: Colors.blue.shade50,
                                gradient: LinearGradient(
                                  colors: [Colors.blue.shade50,Colors.indigo.shade50]
                                )
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15,right: 15,top: 15,bottom: 15),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                        child: ImageWidget(width: 100,book: bok!)),
                                  ),

                                  Expanded(

                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          bok.getBookName(),
                                          maxLines: 2,
                                          overflow:TextOverflow.fade,
                                          style: const TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold,),),

                                        Text(bok.getAuthor(),
                                          maxLines: 2,
                                          style: const TextStyle(color: Colors.grey,fontSize: 15),
                                          overflow:TextOverflow.ellipsis,)
                                      ],
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        IconButton(onPressed: (){}, icon: Icon(Icons.more_horiz)),
                                        Container(
                                          height: 30,
                                          width: 30,
                                          child: CircularProgressIndicator(
                                            color: Colors.indigo,
                                            backgroundColor: Colors.grey.shade200,
                                            value: bok.getPercentageListenedDouble()/100,
                                          ),
                                        )
                                      ],
                                    ),
                                  )

                                ],
                              )

                              // Center(
                              //   child: ListTile(
                              //
                              //     trailing:  (bok!.duration[0] != '0') ? Text(bok.bookLength().substring(0,bok.bookLength().length -7),
                              //       style: const TextStyle(color: Colors.black),) : const Text(""),
                              //     onLongPress: (){
                              //     },
                              //     onTap: (){
                              //       Navigator.push(
                              //           context,
                              //           PageTransition(
                              //               type: PageTransitionType.fade,
                              //               child:  BookDetails(book: bok),
                              //               duration: const Duration(milliseconds: 300)
                              //           )
                              //       );
                              //     },
                              //    // trailing: Text(bok.duration[index]),
                              //     leading: ImageWidget(width: 100,book: bok),
                              //     title: Text(bok.getBookName(),style: const TextStyle(color: Colors.black),),
                              //     subtitle: Text(bok.getAuthor(),style: const TextStyle(color: Colors.black),),
                              //   ),
                              // ),
                            ),
                          ),
                        );
                      });
                },
              )
          ),
        )
      ],
    );
  }
}
