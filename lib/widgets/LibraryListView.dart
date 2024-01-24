import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:page_transition/page_transition.dart';

import '../class/book.dart';
import '../screens/bookDetails/book_details.dart';
import 'bookDetail.dart';
import 'imageWidget.dart';

class LibraryListView extends StatefulWidget {
  LibraryListView({Key? key,required this.books,}) : super(key: key);
  List<Book> books;

  @override
  State<LibraryListView> createState() => _LibraryListViewState();
}

class _LibraryListViewState extends State<LibraryListView> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [

        SliverToBoxAdapter(
          child: SizedBox(
              height: MediaQuery.of(context).size.height*0.85,
              child: (widget.books.isNotEmpty) ? ListView.builder(
                      itemCount: widget.books.length,
                      itemBuilder: (ctx,index){
                        final bok = widget.books[index];
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: GestureDetector(
                            onTap: (){

                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child:  BookDetails(book: bok),
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
                                          child: ImageWidget(width: 100,book: bok)),
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
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          IconButton(onPressed: (){

                                          }, icon: const Icon(Icons.more_horiz)),
                                          if(bok.getPercentageListenedDouble() != double.infinity)SizedBox(
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
                            ),
                          ),
                        );
                },
              ): const Center(child:
              Padding(
                padding: EdgeInsets.only(bottom: 80),
                child: Text("Nothing to Show here"),
              ),
              ),
          ),
        )
      ],
    );
  }
}
