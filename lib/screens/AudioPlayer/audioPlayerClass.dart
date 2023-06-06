import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:echo/player/notifier/play_button_notifier.dart';
import 'package:echo/player/notifier/progress_notifier.dart';
import 'package:echo/screens/AudioPlayer/playlistPage.dart';
import 'package:echo/widgets/imageWidget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:page_transition/page_transition.dart';

import '../../class/book.dart';
import '../../main.dart';
import '../bookDetails/widgets/imgWidget.dart';

enum ProgressState{
  idle,loading,buffering,ready,completed
}
//
// Widget top(BuildContext context){
//   return Row(children : [
//   Padding(
//     padding: const EdgeInsets.only(left: 25,top: 25,),
//     child: IconButton(icon: const Icon(Icons.arrow_back_rounded),onPressed: (){
//       Navigator.of(context).pop();
//     },),
//   ),
//
//   Padding(
//   padding: const EdgeInsets.only(right: 25,top: 25),
//   child: IconButton(onPressed: (){}, icon: const Icon(Icons.bookmark_border_rounded)),
//   ),
//   ]);
// }

class AudioPlayerClass extends StatefulWidget {

  final Book book;
  AudioPlayerClass({Key? key, required this.book,}) : super(key: key);
  @override
  State<AudioPlayerClass> createState() => _AudioPlayerClassState();
}


class _AudioPlayerClassState extends State<AudioPlayerClass> {


  @override
  void initState(){
    pageManager.setBook(widget.book);

    super.initState();

  }

  @override
  void dispose() {


    super.dispose();
  }



  @override
  Widget build(BuildContext context){

    var size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          height: size.height*0.115,
           color: Colors.transparent,
          child:  Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [

              IconButton(
                iconSize: 35,
                color: Colors.grey,
                onPressed: (){

                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.bottomToTop,
                              child: PlaylistPage(book: widget.book,),
                              duration: const Duration(milliseconds: 350)
                          )
                      );

                },
                icon:const Icon(Icons.playlist_play_rounded,),
              ),

              IconButton(
                iconSize: 40,
                color: Colors.indigo,
                onPressed: (){},
                icon:const Icon(Icons.fast_rewind_rounded,),
              ),
              // Expanded(child: Container(),flex: 2,),
              PlayButton(book: widget.book,),
              // Expanded(child: Container(),flex: 2,),
              IconButton(
                iconSize: 40,
                color: Colors.indigo,
                onPressed: (){},
                icon:const Icon(Icons.fast_forward_rounded),
              ),

              IconButton(
                iconSize: 30,
                color: Colors.grey,
                onPressed: (){
                },
                icon:const Icon(Icons.dark_mode_rounded,),
              ),

            ],
          ),
        ),
      ),

      body: CustomScrollView(
        physics: NeverScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(

            expandedHeight: size.height*0.75,
            backgroundColor: Colors.blue.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(size.width*0.15),
                    bottomRight: Radius.circular(size.width*0.15)
              )
            ),


            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,

              title: Container(

                // color: Colors.blue,

                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(onPressed: (){}, icon: Icon(Icons.speed_rounded,color: Colors.grey,)),
                    // IconButton(onPressed: (){}, icon: Icon(Icons.fast_rewind_outlined,color: Colors.grey,)),
                    IconButton(onPressed: (){}, icon: Icon(Icons.timelapse,color: Colors.grey,)),
                  ],
                ),
              ),

              background: Container(
                decoration: BoxDecoration(

                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(size.width*0.1),
                        bottomRight: Radius.circular(size.width*0.1)
                    ),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.blue.shade50,Colors.blue.shade50,Colors.green.shade50]
                    )
                ),
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Container(height: size.height*0.11,),
                  imageWid(size*1.15,context,widget.book),
                  const SizedBox(height: 16,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10,0,10,0),
                    child: Text(
                        widget.book.getBookName(),
                        style:  TextStyle( fontSize: 25,fontWeight: FontWeight.w500,
                            shadows: [Shadow(color: Colors.grey.shade50,offset: Offset(0, 0),blurRadius: 3)]
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.center
                    ),
                  ),

                  SizedBox(height: 1.618,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10,0,10,0),
                    child: Text(
                        'by ${widget.book.getAuthor()}',
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[800]
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.center
                    ),
                  ),
                ],
              )) ,
              collapseMode: CollapseMode.pin,
            ),
            floating: false,
            collapsedHeight: 100,


            leading: Padding(
              padding: const EdgeInsets.only(left: 25,top: 25),
              child: IconButton(icon: const Icon(Icons.arrow_back_rounded),onPressed: (){
                Navigator.of(context).pop();
              },),
            ),

            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 25,top: 25),
                child: IconButton(onPressed: (){}, icon: const Icon(Icons.bookmark_border_rounded)),
              ),

            ],
          ),


          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                     height: size.height*0.01,
                  ),
                  AudioProgressBar(book: widget.book),
                ],
              ),
            ),
          ),


        ],
      ),


    );





    // return Scaffold(
    //
    //
    //   backgroundColor: Colors.blue.shade50,
    //
    //   body: SingleChildScrollView(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.spaceAround ,
    //       children: [
    //         SizedBox(height: val.height*0.03,),
    //         SizedBox(
    //           height: val.height*0.7,
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.end,
    //             children: [
    //               SizedBox(height: val.height*0.09,),
    //               Expanded(
    //                 child: Center(
    //                   child: ClipRRect(
    //                       borderRadius: BorderRadius.circular(10),
    //                       child: ImageWidget(width: 300,book: widget.book,)
    //                   ),
    //                 ),
    //               ),
    //               SizedBox(height: val.height*0.02,),
    //               Padding(
    //                 padding: const EdgeInsets.all(10),
    //                 child: FittedBox(child: Text(widget.book.getBookName(),style: const TextStyle(color:Colors.black,fontSize: 45,fontWeight: FontWeight.bold),)),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.all(10),
    //                 child: FittedBox(child: Text(widget.book.getAuthor(),style: const TextStyle(color:Colors.black,fontSize: 15,),)),
    //               ),
    //             ],
    //           ),
    //         ),
    //         SizedBox(height: val.height*0.02,),
    //         SizedBox(
    //           height: val.height*0.2,
    //           child: Column(
    //             children: [
    //
    //               Padding(
    //                 padding: const EdgeInsets.only(left: 20,right: 20),
    //                 child: AudioProgressBar(book: widget.book),
    //               ),
    //               const SizedBox(height: 10),
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   const SizedBox(width: 10,),
    //                   IconButton(
    //                     iconSize: 25,
    //                     color: Colors.black,
    //                     onPressed: (){},
    //                     icon:const Icon(Icons.bookmark,),
    //                   ),
    //                   Expanded(child: Container()),
    //                   IconButton(
    //                     iconSize: 50,
    //                     color: Colors.black,
    //                     onPressed: (){
    //
    //                     },
    //                     icon:const Icon(Icons.fast_rewind_rounded,),
    //                   ),
    //                   PlayButton(book: widget.book,),
    //                   IconButton(
    //                     iconSize: 50,
    //                     color: Colors.black,
    //                     onPressed: (){
    //
    //                     },
    //                     icon:const Icon(Icons.fast_forward_rounded),
    //                   ),
    //                   Expanded(child: Container()),
    //                   IconButton(
    //                     iconSize: 25,
    //                     color: Colors.black,
    //                     onPressed: (){
    //
    //
    //                     },
    //                     icon:const Icon(Icons.speed,),
    //                   ),
    //                   const SizedBox(width: 10,),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}


class AudioProgressBar extends StatelessWidget {
  final Book book;
  const AudioProgressBar({Key? key,required this.book}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ProgressBarState>(
      valueListenable: pageManager.progressNotifier,
      builder: (_, value, __) {

        return ProgressBar(
          timeLabelTextStyle: const TextStyle(color: Colors.black),
          timeLabelPadding: 8,
          progressBarColor: Colors.indigo,
          baseBarColor: Colors.grey.shade300,
          bufferedBarColor: Colors.indigoAccent.shade100,
          thumbColor: Colors.indigo,
          progress: value.current,
          buffered: value.buffered,
          total: value.total,
          onSeek: (dur){
              pageManager.seek(dur);
          },
          onDragEnd: () {

          },

        );
      },
    );
  }
}


class PlayButton extends StatelessWidget {
  final Book book;
  const PlayButton({Key? key,required this.book}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ButtonState>(
      valueListenable: pageManager.playButtonNotifier,
      builder: (_, value, __) {
        switch (value) {
          case ButtonState.loading:
            return Stack(
              alignment: Alignment.center,
              children: [
                MaterialButton(
                  height: 70,minWidth: 70,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28)
                  ),
                  onPressed: pageManager.play,
                  color: Colors.indigo,
                  child: const Icon(color: Colors.white,
                    size: 40,
                    Icons.play_arrow_rounded,
                  ),
                ),
                const SizedBox(
                    height: 45,
                    width: 45,
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      color: Colors.white,
                    )),
              ],
            );
          case ButtonState.paused:
            return MaterialButton(
              height: 70,minWidth: 70,

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28)
              ),
              onPressed: pageManager.play,
              color: Colors.indigo,
              child: Icon(
                color: Colors.white,
                  size: 40,
               Icons.play_arrow_rounded,
              ),
            );
          case ButtonState.playing:
            return MaterialButton(
              height: 70,minWidth: 70,

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
              ),
               onPressed: () async {

              // await Hive.box<Book>("Lib").put(book.getBookName() + book.id, book);
              pageManager.pause();
              },
              color: Colors.indigo,
              child: const Icon(color: Colors.white,
                size: 40,
                 Icons.pause_rounded,

              ),
            );
        }
      },
    );
  }
}