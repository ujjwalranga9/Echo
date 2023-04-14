import 'package:echo/services/getWebData.dart';
import 'package:echo/widgets/bookDetail.dart';
import 'package:echo/widgets/searchView.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'class/book.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

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
    for(int i = 0 ; i < book.audio.length ; ++i){
     book.duration.add('0');
     book.position.add('0');
    }
  }

  @override
  void initState(){
    super.initState();
   box =   Hive.box<Book>('Lib');
  }

  @override
  void dispose(){
    _textController.dispose();
    super.dispose();
  }
  bool _showCircle = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
          splashRadius: 20,
          icon: const Icon(Icons.arrow_back_rounded,),
        ),

        backgroundColor: const Color.fromRGBO(25, 25 , 25, 1),

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

          style: const TextStyle(color: Colors.white),
          controller: _textController,
          autofocus: true,
          cursorColor: Colors.white,
          decoration:const InputDecoration(
              hintText: "Search audiobook",
              hintStyle: TextStyle(color: Colors.white38),
              border: InputBorder.none,

          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.close_rounded,color: Colors.white,),onPressed: (){
            setState((){
               searchQuery = '';
              _textController.clear();
            });
          }, splashRadius: 20,)
        ],
      ),
      backgroundColor: Colors.black,
      body: (_showCircle == true ) ? const Center(
        child: CircularProgressIndicator(color: Color(0xff6E0097)),
        ) :
            ListView.builder(itemCount: books.length,itemBuilder: (ctx,index){

              return Padding(
                padding: const EdgeInsets.only(left: 15,right: 15,top: 10,),
                child: Container(
                  decoration: BoxDecoration(
                      color:const Color.fromRGBO(15, 15 , 15, 1),
                    borderRadius: BorderRadius.circular(10)
                  ),


                  child: ListTile(
                    onTap: (){
                      getAudioLength((books[index]));
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) {
                            return BookDetail(
                              book: books[index],
                            );
                          })
                      );
                    },

                    trailing: MaterialButton(
                      shape: !(box.containsKey(books[index].getBookName() + books[index].id) ) ? ShapeBorder.lerp(
                          Border.all(width: 1,),
                          Border.all(width: 1), 0) : ShapeBorder.lerp(
                          Border.all(width: 1,color: Colors.white38),
                          Border.all(width: 1), 0),
                      color: !(box.containsKey(books[index].getBookName() + books[index].id) ) ? const Color(0xff6E0097) :Colors.white10 ,
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
                            box.put(books[index].getBookName() + books[index].id,books[index]);
                          }
                        });
                      },
                      child:  Text( !(box.containsKey(books[index].getBookName() + books[index].id) ) ? "Add to Lib" : "Remove"),
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
                    title: Text(books[index].getBookName(),style: const TextStyle(color: Colors.white),),
                    subtitle:Text(books[index].getAuthor(),style:const TextStyle(color: Colors.white),),
                  ),
                ),
              );
            }),
    );
  }
}
