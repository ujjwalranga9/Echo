import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../class/book.dart';
import '../main.dart';
import 'bookDetail.dart';
import 'imageWidget.dart';

class LibraryGrid extends StatelessWidget {
  const LibraryGrid({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

     // var box = Hive.box<Book>('Lib');
     //
     //
     // List<Book> books = [];
     // for(int i = 0 ; i <box.length ; i++){
     //   books.add(box.getAt(i)!);
     // }
     //


    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(
              height: MediaQuery.of(context).size.height*0.88,
              child: ValueListenableBuilder(
                valueListenable: Hive.box<Book>('Lib').listenable(),
                builder: (context , Box<Book>box,_){
                   return GridView.builder(
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
                                        box.delete(box.getAt(index)!.getBookName() + box.getAt(index)!.id);
                                        Navigator.of(ctx).pop(true);
                                      },
                                        color: Theme.of(context).primaryColor,
                                        child:const Text("Yes",style: TextStyle(color: Colors.white),),
                                      ),

                                    ],

                                    content: const Text("Are you sure you want to delete this item?",style: TextStyle(color: Colors.white),),
                                  ));
                            },

                             onTap: (){
                               Navigator.of(context).push(MaterialPageRoute(builder: (ctx){

                                 return BookDetail(book: box.getAt(index)!,);
                               }));
                             },
                             child: Stack(
                               alignment: Alignment.bottomCenter,
                               children: [
                                 ClipRRect(
                                     borderRadius: BorderRadius.circular(10),
                                     child: ImageWidget(book: box.getAt(index)!,width: 175,height: 260)),


                                 Row(
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [


                                     // Length of Book
                                     if(timing)Padding(
                                       padding: const EdgeInsets.only(bottom: 1,left: 1),
                                       child: Container(
                                         decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                                           color: Colors.black54,
                                         ),
                                         child: Padding(
                                           padding: const EdgeInsets.only(left: 5,right: 5,bottom: 2,top: 2),
                                           child: Container(
                                               child: (box.getAt(index)!.duration[0] != '0') ? Text(box.getAt(index)!.getPercentageListened(),style:
                                               const TextStyle(color: Colors.white),) : const Text("0%")),
                                         ),
                                       ),
                                     ),

                                    // Percentage on Book
                                     if(timing)Padding(
                                       padding: const EdgeInsets.only(bottom: 1,right: 1),
                                       child: Container(
                                         decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                                           color: Colors.black54,
                                         ),
                                         child: Padding(
                                           padding: const EdgeInsets.only(left: 5,right: 5,bottom: 2,top: 2),
                                           child: Container(
                                               child: (box.getAt(index)!.duration[0] != '0') ? Text(box.getAt(index)!.bookLength().substring(0,box.getAt(index)!.bookLength().length -7),style:
                                               const TextStyle(color: Colors.white),) : const Text("")),
                                         ),
                                       ),
                                     ),


                                   ],
                                 )



                               ],
                             ));
                       } ,
                     itemCount: box.length,
                   );
                },
              )
          ),
        ),
      ],
    );
  }
}
