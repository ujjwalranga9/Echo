
import 'dart:async';
import 'dart:io';
import 'package:echo/main.dart';
import 'package:echo/services/download.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:html/parser.dart';
import 'package:just_audio/just_audio.dart';
import 'package:page_transition/page_transition.dart';
import '../audioPlayerPage.dart';
import '../class/book.dart';
import 'imageWidget.dart';


class BookDetail extends StatefulWidget {
  final Book book;
  Function update;
  BookDetail({Key? key, required this.book,required this.update}) : super(key: key);

  @override
  State<BookDetail> createState() => _BookDetailState();
}



class _BookDetailState extends State<BookDetail> {

  bool isInLib = false;
  Duration duration = Duration.zero;
  List<String> oldPosition=[];



  String? _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String? parsedString = parse(document.body?.text).documentElement?.text;

    return parsedString;
  }

  @override
  void initState(){
    super.initState();
    var box = Hive.box<Book>("Lib");
    if(box.containsKey(widget.book.getBookName() + widget.book.id)){
      setState((){
        isInLib = true;
      });
    }
    for(int i = 0 ; i < widget.book.position.length ; i++){
      oldPosition.add(widget.book.position[i]);
    }
    AudioPlayerPage.oldPosition = oldPosition;

  }


  Widget progressIndicator(int index){
    return  ClipRRect(
      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight:Radius.circular(10) ),
      child: LinearProgressIndicator(
        backgroundColor: const Color(0xff303030),
        value:  widget.book.getListenedIndexLength(index),
      ),
    );
  }

  Future<void> setLength() async {

    AudioPlayer audioPlayer = AudioPlayer();
    for(int i = 0 ; i < widget.book.audio.length ; ++i){
       await audioPlayer.setUrl(widget.book.audio[i]);
       widget.book.duration[i] = audioPlayer.duration.toString();
         setState((){});

    }
    audioPlayer.dispose();
  }

  Future<bool> updateState() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {});
    widget.update();
    return true;
  }




  bool gettingAudioLength = false;
  bool storyWidget = false;

  @override
  Widget build(BuildContext context) {

    //TabController _tabController = TabController(length: 2, vsync: this);

    var val = MediaQuery.of(context);
    return DefaultTabController(
      length: 2,
      child: WillPopScope(
        onWillPop: () async {
          await widget.update();
          return true;
        },
        child: Scaffold(

           backgroundColor: Colors.black,
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                    children: [
                      SizedBox(
                        height: (val.orientation == Orientation.portrait) ? val.size.height*0.32 : val.size.height*0.4,
                        width: val.size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15,right: 15,bottom: 15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    ImageWidget(book: widget.book,width: 175,height: 260),
                                    Container(width: 175,height: 260,decoration: BoxDecoration(border: Border.all(width: 0.5,color: Colors.grey),borderRadius: BorderRadius.circular(10)),)
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10,),
                              SizedBox(
                                width: val.size.width/2,
                                height: 250,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10,top: 5,right: 10,),
                                      child: Text(widget.book.getBookName(),
                                        maxLines: (val.orientation == Orientation.portrait) ? 3 : 1,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                   const SizedBox(height: 5,),
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

                                    const SizedBox(height: 5,),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10,right: 10,),
                                      child: FittedBox(
                                        child: GestureDetector(
                                          onTap: () async {

                                            setState(()  {
                                              gettingAudioLength = true;
                                            });
                                            await setLength().then((value) {

                                              var box = Hive.box<Book>("Lib");
                                              box.put(widget.book.getBookName() + widget.book.id, widget.book);
                                              pageManager.setBook(Hive.box<Book>("Play").getAt(0)!);

                                              setState(()  {
                                                gettingAudioLength = false;
                                              });
                                            });

                                          },
                                         child: Text((widget.book.duration[0] == '0' && gettingAudioLength == false) ? "Get Duration" :
                                                         (gettingAudioLength == true) ? "Getting..." :
                                                          widget.book.bookLength().substring(0,widget.book.bookLength().length-7),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,),
                                          overflow: TextOverflow.ellipsis,)
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 5,),


                                    FittedBox(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 0,right: 10,),
                                        child: Row(
                                          children: [


                                            const SizedBox(width: 10,),
                                            MaterialButton(
                                              shape: ShapeBorder.lerp(Border.all(width: 1,color: Colors.white38), Border.all(width: 1), 0),
                                              color: Colors.white10 ,
                                              textColor: Colors.white,
                                              onPressed: (){
                                                var box =   Hive.box<Book>('Lib');
                                                 setState((){

                                                   if(box.containsKey(widget.book.getBookName() + widget.book.id)){
                                                     setState((){
                                                       isInLib = false;
                                                       box.delete(widget.book.getBookName() + widget.book.id);
                                                     });

                                                   }else {
                                                     setState((){
                                                       isInLib = true;
                                                       box.put(widget.book.getBookName() + widget.book.id,widget.book);
                                                     });
                                                   }
                                                 });
                                              },
                                              child:  Text( (isInLib == false ) ? "Add to Lib" : "Remove"),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: val.size.height*0.04,
                          child:const  TabBar(
                              tabs: [
                                Tab(text: "Audio",),
                                Tab(text: "Story",),
                              ],
                            )
                      ),

                      SizedBox(

                        height: val.size.height*0.6,

                        child: TabBarView(
                          children: [
                            ListView.builder(

                                itemCount: widget.book.audio.length,
                                itemBuilder: (ctx,index){



                                  return Padding(
                                    padding: const EdgeInsets.only(left: 15,right: 15,top: 10,),
                                    child: Container(
                                      decoration: const BoxDecoration(

                                          color: //Colors.white,
                                          Color.fromRGBO(15, 15 , 15, 1),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight:Radius.circular(10),
                                            bottomLeft: Radius.circular(5),
                                            bottomRight: Radius.circular(5),
                                          )
                                      ),

                                      child: Stack(
                                        alignment: Alignment.bottomCenter,
                                        children: [
                                          ListTile(

                                            onTap: (){
                                              AudioPlayerPage.audioFileNo = index;
                                              // Navigator.of(context).push(
                                              //     MaterialPageRoute(builder: (ctx) {
                                              //       return AudioPlayerPage(book: widget.book,saved: downloaded("${widget.book.title}_$index") == true ? true :false ,updateBookDetail: updateState,);
                                              //     })
                                              // );


                                              Navigator.push(
                                                  context,
                                                  PageTransition(type: PageTransitionType.fade, child:  AudioPlayerPage(book: widget.book,saved: downloaded("${widget.book.title}_$index") == true ? true :false ,updateBookDetail: updateState,),duration: Duration(milliseconds: 300))
                                              ).then((value) {
                                                setState(() {
                                                  print("Updated");
                                                  updateState();
                                                  progressIndicator(AudioPlayerPage.audioFileNo);
                                                });
                                              });


                                            },

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
                                                    final dir = externalDirectory;
                                                    final filePath = '${dir.path}/${widget.book.title}_$index.mp3';
                                                    File(filePath).delete();
                                                    // box.delete(box.getAt(index)!.getBookName() + box.getAt(index)!.id);
                                                    Navigator.of(ctx).pop(true);
                                                    setState(() { });
                                                  },
                                                    color: Theme.of(context).primaryColor,
                                                    child:const Text("Yes",style: TextStyle(color: Colors.white),),
                                                  ),

                                                ],

                                                content: const Text("Are you sure you want to delete this item?",style: TextStyle(color: Colors.white),),
                                              ));
                                            },

                                            trailing: IconButton( onPressed: (){
                                                print("\nDownload Started");
                                                downloadAudioFile(widget.book.audio[index],"${widget.book.title}_$index").then((value) {
                                                  print("\nDownload Finished");
                                                  setState(() {});
                                                });

                                            },icon: Icon(  downloaded("${widget.book.title}_$index") == true ? Icons.file_download_done :Icons.file_download_outlined,color:downloaded("${widget.book.title}_$index") == true ? Theme.of(context).primaryColor : Colors.white,),
                                              splashRadius: 20,
                                            ),



                                            subtitle:  (widget.book.duration[index] == '0') ? Text(widget.book.duration[index], style: const TextStyle(color: Colors.white),):
                                            Text(widget.book.duration[index].substring(0,widget.book.duration[index].length-7),style: const TextStyle(color: Colors.white)),
                                            leading: ClipRRect(
                                                borderRadius: BorderRadius.circular(10),
                                                child: Stack(
                                                  children: [
                                                    ImageWidget(book: widget.book,width: 55,height: 55,),
                                                    Container(width: 55,height: 55,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),border: Border.all(width: 0.5,color: Colors.grey)),)
                                                  ],
                                                )
                                            ),
                                            title: Text('${index+1}. ${widget.book.getBookName()}',
                                              style: const TextStyle(color: Colors.white),),
                                            //subtitle:Text(widget.book.getAuthor(),style:const TextStyle(color: Colors.white),),
                                          ),
                                          progressIndicator(index),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                            Padding(
                              padding: const EdgeInsets.only(left: 10,right: 10),
                              child: Container(
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),
                                  //color: Colors.white
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10,right: 10, ),
                                  child: SingleChildScrollView(
                                    child: Text('\n${_parseHtmlString(widget.book.getStory())!}',style: const TextStyle(color: Colors.white,fontSize: 16),),
                                  ),
                                ),
                              ),

                            ),

                          ],
                        )
                      ),
                    ]),
              ),
            )
        ),
      ),
    );
  }
}

