import 'package:echo/services/getWebData.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../class/book.dart';

class SearchView extends StatefulWidget {
    Book book;

  SearchView({Key? key,
    required this.book,
  }) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {

  List<Book> books= [];
  bool isInLib = false;

 void getAudioLength()  {
    for(int i = 0 ; i < widget.book.audio.length ; ++i){
      widget.book.duration.add('0');
      widget.book.position.add('0');
    }
  }

  @override
  void initState(){
    super.initState();
    var box = Hive.box<Book>("Lib");

    if(box.containsKey(widget.book.getBookName() + widget.book.id)) {
      isInLib = true;
    }

    GetWebData.getWebsiteDataInFormOfBook('https://dailyaudiobooks.com/?s=${widget.book.getAuthor()}', true)
        .then((value) { books = value;

    if (mounted) {
      setState(() {
        _showCircle = false;
      });
    }
        });
  }

  late bool _showCircle = true;

  @override
  Widget build(BuildContext context) {
    var val = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: SizedBox(
                    height: val.height*0.3,
                    width: val.width,
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            widget.book.getImage(),
                            width: 175,
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                              return Image.asset('audiobook.png',fit: BoxFit.cover,width: 175,);
                            },

                          ),
                        ),
                        const SizedBox(width: 10,),
                        SizedBox(
                          width: val.width/2,
                          height: 250,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [

                              //Book Name
                              Padding(
                                padding: const EdgeInsets.only(left: 10,top: 8,right: 10,),
                                child: Text(widget.book.getBookName(),
                                  maxLines: 3,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 10,),
                              //Book Author
                              Padding(
                                padding: const EdgeInsets.only(left: 10,right: 10,),
                                child: FittedBox(
                                  child: Text(widget.book.getAuthor(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.only(left: 10,right: 10,),
                                child: Row(
                                  children: [
                                    // MaterialButton(
                                    //   color:const Color(0xff6E0097),
                                    //   textColor: Colors.white,
                                    //   onPressed: (){
                                    //     Navigator.of(context).push(
                                    //         MaterialPageRoute(builder: (_) {
                                    //           getAudioLength();
                                    //           AudioPlayerPage.audioFileNo = -2;
                                    //           return AudioPlayerPage(book: widget.book,);
                                    //         })
                                    //     );
                                    //   },
                                    //   child: const Text("Listen Now"),
                                    // ),
                                    //const SizedBox(width: 10,),
                                    MaterialButton(
                                      shape: (isInLib == false ) ? ShapeBorder.lerp(
                                          Border.all(width: 1,),
                                          Border.all(width: 1), 0) : ShapeBorder.lerp(
                                          Border.all(width: 1,color: Colors.white38),
                                          Border.all(width: 1), 0),
                                      color: (isInLib == false ) ? const Color(0xff6E0097) :Colors.white10 ,
                                      textColor: Colors.white,
                                      onPressed: (){
                                        ScaffoldMessenger.of(context).showSnackBar(

                                          const SnackBar(content: Text('Done'),duration: Duration(seconds: 1),backgroundColor: Color(0xff202020),),
                                        );
                                        var box =   Hive.box<Book>('Lib');
                                        setState((){

                                          if(box.containsKey(widget.book.getBookName() + widget.book.id)){

                                              isInLib = false;

                                            box.delete(widget.book.getBookName() +widget.book.id);
                                          }else {
                                            isInLib = true;
                                            getAudioLength();
                                            box.put(widget.book.getBookName() + widget.book.id,widget.book);

                                          }
                                        });
                                      },
                                      child:  Text( (isInLib == false ) ? "Add to Lib" : "Remove"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 15),
                  height: val.height*0.06,

                  child: const Text("More from Author",style: TextStyle(color: Colors.white,fontSize: 20),),
                ),
                SizedBox(
                  height: val.height*0.56,
                  child: (_showCircle == true ) ? const Center(
                  child: CircularProgressIndicator(color: Color(0xff6E0097)),
                 ) :
                  ( books.length != 1 ) ?
                    ListView.builder(itemCount: books.length,itemBuilder: (ctx,index){

                    if(books[index].id == widget.book.id) return Container();
                     return Padding(
                    padding: const EdgeInsets.only(left: 15,right: 15,top: 10,),
                      child: Container(
                      decoration: BoxDecoration(
                          color:const Color.fromRGBO(15, 15 , 15, 1),
                          borderRadius: BorderRadius.circular(10)
                      ),


                      child: ListTile(
                        onTap: (){
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) {
                                return SearchView(book: books[index]);
                              })
                          );
                        },

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
                 }) : const Center(child: Text("Nothing to show here",style: TextStyle(color: Colors.white,fontSize: 22),),),
                ),
            ]),
          ),
        )


    );
  }
}
