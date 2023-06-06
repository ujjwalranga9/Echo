import 'package:echo/screens/bookDetails/book_details.dart';
import 'package:echo/services/download.dart';
import 'package:echo/services/getWebData.dart';
import 'package:echo/widgets/bookDetail.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';
import 'class/book.dart';

class Search extends StatefulWidget {
  Search({required this.update,Key? key}) : super(key: key);
  Function update;
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  final _textController = TextEditingController();
  late String searchUrl = 'https://dailyaudiobooks.com/?s=';
  late String searchQuery = '';
  var box;
  List<Book> books= [];

  void getAudioLength(Book book)  {
    if(book.duration.isNotEmpty){return;}
    for(int i = 0 ; i < book.audio.length ; i++){
     book.duration.add('0');
     book.position.add('0');
    }
  }

  @override
  void initState(){
    super.initState();
   box =   Hive.box<Book>('Lib');
  }

  void updateSearch(){
    setState(() {});
  }

  @override
  void dispose(){
    _textController.dispose();
    super.dispose();
  }
  bool _showCircle = false;
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        print("Search Updated");
        await widget.update();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: (){
                Navigator.of(context).pop();
              },
            splashRadius: 20,
            icon: const Icon(Icons.arrow_back_rounded,),
          ),

          backgroundColor: Colors.blue.shade50,

          title: TextField(
            onSubmitted: (value) async {
              books = [];
              searchQuery = "";
              searchUrl = 'https://dailyaudiobooks.com/?s=';
              searchQuery = value;
              searchQuery.trim();
              searchQuery = searchQuery.replaceAll(' ', '%20');
              searchUrl = searchUrl + searchQuery;

              setState((){
                _showCircle = true;
              });
              await GetWebData.getWebsiteDataInFormOfBook(searchUrl,true).then((value) => setState((){
                books = value;
               // print(books);
              }));
              setState(() {
                _showCircle = false;
              });

            },

            style: const TextStyle(color: Colors.black),
            controller: _textController,
            autofocus: true,
            cursorColor: Colors.black,
            decoration:const InputDecoration(
                hintText: "Search audiobook",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,

            ),
          ),
          actions: [
            IconButton(icon: const Icon(Icons.close_rounded,color: Colors.black,),onPressed: (){
              setState((){
                 searchQuery = '';
                _textController.clear();
              });
            }, splashRadius: 20,)
          ],
        ),
        backgroundColor: Colors.white,
        body: (_showCircle == true ) ? const Center(
          child: CircularProgressIndicator(color: Colors.blue),
          ) :
              ListView.builder(itemCount: books.length,itemBuilder: (ctx,index){

                return Padding(
                  padding: const EdgeInsets.only(left: 15,right: 15,top: 10,),
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(20)
                    ),


                    child: Center(
                      child: ListTile(
                        onTap: (){
                          // getAudioLength((books[index]));

                          // Navigator.of(context).push(
                          //     MaterialPageRoute(builder: (_) {
                          //       return BookDetail(
                          //         book: books[index],
                          //         update: updateSearch,
                          //       );
                          //     })
                          // );

                          // Navigator.push(
                          //     context,
                          //     PageTransition(
                          //         type: PageTransitionType.fade,
                          //         child:  BookDetails(book: books[index]),
                          //         duration: const Duration(milliseconds: 300)
                          //     )
                          // );


                        },

                        trailing: MaterialButton(
                          // shape: !(box.containsKey(books[index].getBookName() + books[index].id) ) ? ShapeBorder.lerp(
                          //     Border.all(width: 1,),
                          //     Border.all(width: 1), 0) : ShapeBorder.lerp(
                          //     Border.all(width: 1,color: Colors.white38),
                          //     Border.all(width: 1), 0),
                          color: !(box.containsKey(books[index].getBookName() + books[index].id) ) ?  Colors.indigo:Colors.grey ,
                          textColor: Colors.white,
                          onPressed: (){
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Done'),duration: Duration(seconds: 1),backgroundColor: Color(0xff202020),),
                            );
                            setState((){
                              if(box.containsKey(books[index].getBookName() + books[index].id)){
                                box.delete(books[index].getBookName() +books[index].id);
                              }else {
                                getAudioLength((books[index]));
                                setLength(books[index],(){

                                });
                                box.put(books[index].getBookName() + books[index].id,books[index]);
                              }
                            });
                          },
                          child:  Text( !(box.containsKey(books[index].getBookName() + books[index].id) ) ? "Add to Lib" : " Removed "),
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                              books[index].getImage(),
                              width: 55,
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                              return Image.asset('audiobook.png',fit: BoxFit.cover,width: 55,);
                            },
                          ),
                        ),
                        title: Text(books[index].getBookName(),style: const TextStyle(color: Colors.black),),
                        subtitle:Text(books[index].getAuthor(),style:const TextStyle(color: Colors.black),),
                      ),
                    ),
                  ),
                );
              }),
      ),
    );
  }
}
