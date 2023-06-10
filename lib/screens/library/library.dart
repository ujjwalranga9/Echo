
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:echo/screens/bookDetails/widgets/imgWidget.dart';
import 'package:echo/widgets/deleteDialog.dart';
import 'package:echo/widgets/imageWidget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';

import '../../class/book.dart';
import '../bookDetails/book_details.dart';

class Lib extends StatefulWidget {
  const Lib({super.key});

  @override
  State<Lib> createState() => _LibState();
}

class _LibState extends State<Lib> {

  List<Book> books = [];

  List<Book> searchBook = [];



  @override
  void initState() {
    var box = Hive.box<Book>("Lib");

    for(int i = 0 ; i < box.length ; i++){
      books.add(box.getAt(i)!);
      searchBook.add(box.getAt(i)!);
    }



    super.initState();
  }



  String search = '';
  final controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    var size = const Size (370,200);

    return Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        backgroundColor: Colors.blue.shade50,

        appBar: AppBar(

          elevation: 0,
          title: TextField(
            cursorColor: Colors.black,
            decoration:const InputDecoration(
              hintText: "Search in Library",
              hintStyle: TextStyle(color: Colors.black12,fontWeight: FontWeight.w400),
              border: InputBorder.none,
            ),
            controller: controller,
            onChanged: (val){
              search = val;
              searchBook.clear();
              for(int i = 0; i < books.length ; i++){
                if(books[i].title.toLowerCase().contains(val.toLowerCase())){
                  // print('$val  ${books[i].getBookName()}');
                  searchBook.add(books[i]);
                }
              }
              setState(() {});
            },
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          ),
          centerTitle: true,

          backgroundColor: Colors.white,

          actions: [
            IconButton(onPressed: (){
              setState(() {
              });
            }, icon: const Icon(Icons.search_rounded))
          ],

        ),

        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // SliverAppBar(
                //   elevation: 0,
                //   title: TextField(
                //     cursorColor: Colors.black,
                //     decoration:const InputDecoration(
                //       hintText: "Search in Library",
                //       hintStyle: TextStyle(color: Colors.black12,fontWeight: FontWeight.w400),
                //       border: InputBorder.none,
                //     ),
                //     controller: controller,
                //     onChanged: (val){
                //       search = val;
                //       searchBook.clear();
                //       for(int i = 0; i < books.length ; i++){
                //         if(books[i].title.toLowerCase().contains(val.toLowerCase())){
                //           // print('$val  ${books[i].getBookName()}');
                //           searchBook.add(books[i]);
                //         }
                //       }
                //       setState(() {});
                //     },
                //   ),
                //     floating: true,
                //     pinned: true,
                //
                //     // shape: RoundedRectangleBorder(
                //     //   borderRadius: BorderRadius.circular(20)
                //     // ),
                //
                //
                //     backgroundColor: Colors.white,
                //
                //     actions: [
                //       IconButton(onPressed: (){
                //         setState(() {
                //         });
                //       }, icon: const Icon(Icons.search_rounded))
                //     ],
                //
                // ),
               if(search == '') Padding(
                 padding: const EdgeInsets.only(top: 20,),
                 child: CarouselSlider(
                     items: [
                       imageWid(size, context, books[Random().nextInt(books.length)]),
                       imageWid(size, context, books[Random().nextInt(books.length)]),
                       imageWid(size, context, books[Random().nextInt(books.length)]),
                       imageWid(size, context, books[Random().nextInt(books.length)]),
                       imageWid(size, context, books[Random().nextInt(books.length)]),
                     ],
                     options: CarouselOptions(
                       height: 260,
                       enlargeCenterPage: true,
                       autoPlay: true,
                       autoPlayCurve: Curves.fastOutSlowIn,
                       aspectRatio: 9/16,
                       enableInfiniteScroll: true,
                       autoPlayAnimationDuration: const Duration(seconds: 1),
                       viewportFraction: 0.45

                     )
                 ),
               ),

                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(top: 20,left: 20),
                      child: Text("Library",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 15,right: 15,top: 10),
                  child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: searchBook.length,

                      gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 4/6,

                      ),

                      itemBuilder: (context,index){
                        return GestureDetector(
                            onTap: (){
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child:  BookDetails(book: searchBook[index]),
                                      duration: const Duration(milliseconds: 300)
                                  )
                              );
                            },
                            onLongPress: (){

                              // Hive.box<Book>('Lib').delete(searchBook[index].getBookName()+searchBook[index].id);
                              deleteDialog(book: searchBook[index], context: context).then((value) {
                                // print(value);
                                if(value == true){
                                  searchBook.removeAt(index);
                                  books.removeWhere((element) => element.getBookName() + element.id == searchBook[index].getBookName()+searchBook[index].id);

                                }
                                setState(() {});
                              });
                              setState(() {});
                            },
                            child: imageWid(MediaQuery.of(context).size, context, searchBook[index])
                        );
                      }),
                ),

              ],

            ),
          ),
        ),

    );
  }
}
