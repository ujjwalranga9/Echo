import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../class/book.dart';
import 'bookDetail.dart';
import 'imageWidget.dart';

class LibraryList extends StatefulWidget {
  const LibraryList({Key? key}) : super(key: key);

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
              height: MediaQuery.of(context).size.height*0.88,
              child: ValueListenableBuilder(
                valueListenable: Hive.box<Book>('Lib').listenable(),
                builder: (context , Box<Book>box,_){
                  return ListView.builder(
                      itemCount: box.length,
                      itemBuilder: (ctx,index){
                        final bok = box.getAt(index);
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius:BorderRadius.circular(10),
                              color: const Color(0xff191919)
                          ),
                          child: Dismissible(
                            confirmDismiss: (direction){
                              return showDialog(

                                  context: context,
                                  builder: (ctx)=>AlertDialog(
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
                                        Navigator.of(ctx).pop(true);
                                      },
                                        color: Theme.of(context).primaryColor,
                                        child:const Text("Yes",style: TextStyle(color: Colors.white),),
                                      ),
                                    ],

                                    content: const Text("Are you sure you want to delete this item?",style: TextStyle(color: Colors.white),),
                                  ));
                            } ,
                            onDismissed: (direction){
                              box.delete(bok!.getBookName() + bok.id);
                            },
                            direction: DismissDirection.endToStart,
                            background: Container(
                              decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(10)),

                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              // margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 4),
                              child: const Icon(Icons.delete,color: Colors.white,size: 40,),
                            ),
                            key: ValueKey(bok!.id),
                            child: ListTile(
                              trailing:  (bok.duration[0] != '0') ? Text(bok.bookLength().substring(0,bok.bookLength().length -7),style: const TextStyle(color: Colors.white),) : const Text(""),
                              onLongPress: (){
                              },
                              onTap: (){
                                Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) {
                                      return  BookDetail(book: bok,);
                                    })
                                );
                              },
                             // trailing: Text(bok.duration[index]),
                              leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: ImageWidget(height: 55,width: 55,book: bok)
                              ),
                              title: Text(bok.getBookName(),style: const TextStyle(color: Colors.white),),
                              subtitle: Text(bok.getAuthor(),style: const TextStyle(color: Colors.white),),
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
