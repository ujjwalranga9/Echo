import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../class/book.dart';
import '../main.dart';
import '../screens/bookDetails/book_details.dart';
import 'imageWidget.dart';

class LibraryGrid extends StatefulWidget {
   LibraryGrid({required this.update,required this.temp,required  this.delete,required this.stateOfBook,Key? key}) : super(key: key);



  Function delete;
  Function update;
  Box<Book> temp;
  int stateOfBook;

  @override
  State<LibraryGrid> createState() => _LibraryGridState();
}

class _LibraryGridState extends State<LibraryGrid> {
  @override
  Widget build(BuildContext context) {

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Container(
              color: Theme.of(context).backgroundColor,
              height: MediaQuery.of(context).size.height*0.91,
              child: ValueListenableBuilder(
                valueListenable: widget.temp.listenable(),
                builder: (context , Box<Book> box,_){
                  List<Book> values = widget.temp.values.toList();
                     if(sortByLength) {
                       values.sort((a,b)=> a.parseDuration(a.bookLength()).compareTo(b.parseDuration(b.bookLength())));
                       print("sort Done");
                     }


                   return (values.isNotEmpty) ? GridView.builder(
                     itemCount: values.length,
                       gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                         crossAxisCount: 3,
                         crossAxisSpacing: 10,
                         mainAxisSpacing: 10,
                         childAspectRatio: 4/6,
                       ),
                       padding: const EdgeInsets.all(10),
                       itemBuilder: (ctx,index){
                         return  GestureDetector(

                            onLongPress: (){
                              bool read = false;
                              bool done = false;
                              bool newBook = false;
                              showDialog(context: context, builder: (ctx)=>AlertDialog(
                                    backgroundColor: const Color(0xff202020),
                                    title:const Center(child: Text("Are you Sure?",style: TextStyle(color: Colors.white),)),

                                    actions: [
                                      MaterialButton(onPressed: (){
                                        Navigator.of(ctx).pop(false);
                                      },
                                        color: Theme.of(context).primaryColor,
                                        child: const Text("NO",style: TextStyle(color: Colors.white),),
                                      ),
                                      MaterialButton(onPressed: (){
                                        widget.delete(values[index].getBookName() +values[index].id);
                                        Navigator.of(ctx).pop(true);

                                      },
                                        color: Theme.of(context).primaryColor,
                                        child:const Text("Yes",style: TextStyle(color: Colors.white),),
                                      ),

                                    ],

                                    content: SizedBox(

                                      height: 70,
                                      child: Column(
                                        children: [
                                          Row(

                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                            children:   [
                                              ChoiceChip(
                                                label:  Text("ToRead",style: TextStyle(color: (widget.stateOfBook == 0)? Colors.white : Colors.purple ),), backgroundColor: (widget.stateOfBook == 0)? Colors.purple : Colors.grey,
                                                selected: newBook,onSelected: (b){
                                                values[index].newBook();
                                                   newBook = b;
                                                  Hive.box<Book>("Lib").put(values[index].getBookName() + values[index].id, values[index]);
                                                  Navigator.of(ctx).pop(true);
                                                  widget.update();
                                              },),
                                              ChoiceChip(
                                                label:  Text("Reading",style: TextStyle(color: (widget.stateOfBook == 1)? Colors.white : Colors.purple ),),backgroundColor: (widget.stateOfBook == 1)? Colors.purple : Colors.grey,
                                                selected: read,onSelected: (b){
                                                values[index].reading();
                                                   read = b;
                                                    Hive.box<Book>("Lib").put(values[index].getBookName() +values[index].id, values[index]);
                                                    Navigator.of(ctx).pop(true);
                                                    widget.update();
                                              },),
                                              ChoiceChip(
                                                label:  Text("Done",style: TextStyle(color: (widget.stateOfBook == 2)? Colors.white : Colors.purple ),),backgroundColor: (widget.stateOfBook == 2)? Colors.purple : Colors.grey,

                                                selected: done,onSelected: (b){
                                                values[index].done();
                                                  done = b;
                                                  Hive.box<Book>("Lib").put(values[index].getBookName() + values[index].id,values[index]);
                                                  Navigator.of(ctx).pop(true);
                                                  widget.update();
                                              },),
                                            ],
                                          ),
                                          const Text("Are you sure you want to delete this item?",style: TextStyle(color: Colors.white),),
                                        ],
                                      ),
                                    ),
                                  ));
                            },

                             onTap: (){

                               Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                                 return BookDetails(book: values[index],);
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
                                         Hero(
                                             tag: "image",
                                            child: ImageWidget(book: values[index],width: 178.3,height: 265)),
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
                                                   child: (values[index].duration[0] != '0') ? Text(values[index].bookLength().substring(0,values[index].bookLength().length -7),style:
                                                   const TextStyle(color: Colors.white),) : const Text("")),
                                             ),
                                           ),
                                         ),

                                       ],
                                     ),
                                 ),


                                 // Row(
                                 //
                                 //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 //   children: [
                                 //
                                 //
                                 //     // Percentage of Book
                                 //     if(timing)Padding(
                                 //       padding: const EdgeInsets.only(bottom: 1,left: 1),
                                 //       child: Container(
                                 //
                                 //         decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                                 //           color: Colors.black54,
                                 //         ),
                                 //         child: Padding(
                                 //           padding: const EdgeInsets.only(left: 5,right: 5,bottom: 2,top: 2),
                                 //           child: Container(
                                 //               child: (box.getAt(index)!.duration[0] != '0') ? Text(box.getAt(index)!.getPercentageListened(),style:
                                 //               const TextStyle(color: Colors.white),) : const Text("0%")),
                                 //         ),
                                 //       ),
                                 //     ),
                                 //
                                 //
                                 //
                                 //   ],
                                 // ),

                                 // Positioned(
                                 //
                                 //   top: 8,left: 75,
                                 //
                                 //
                                 //   child: Transform.rotate(
                                 //
                                 //      angle:  0.8,
                                 //       child: Container(
                                 //         color: Colors.black,
                                 //           height: 16,
                                 //           width: 70,
                                 //           child:Center(
                                 //             child: FittedBox(
                                 //             child: (values[index].duration[0] == '0') ?  const Text("NEW",style: TextStyle(color: Colors.white,fontSize: 12),)
                                 //                 : (values[index].getPercentageListened() != '100%') ? Text(values[index].getPercentageListened(),style: const TextStyle(color: Colors.white,fontSize: 12,),) :
                                 //             const Text("READ",style: TextStyle(color: Colors.white,fontSize: 12),)
                                 //             ) ,
                                 //           ),
                                 //
                                 //           ),
                                 //       ),
                                 // ),

                               ],
                             ));
                       } ,

                   ): const Center(child:
                   Padding(
                     padding: EdgeInsets.only(bottom: 80),
                     child: Text("Nothing to Show here"),
                   ),
                   );
                },
              )
          ),
        ),
      ],
    );
  }
}
