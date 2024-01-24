
import 'dart:async';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:echo/player/notifier/play_button_notifier.dart';
import 'package:echo/player/notifier/progress_notifier.dart';
import 'package:echo/screens/AudioPlayer/playlistPage.dart';
import 'package:echo/widgets/sleepBottomSheet.dart';
import 'package:echo/widgets/sliderDialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../../class/book.dart';
import '../../class/staticValue.dart';
import '../../main.dart';
import '../bookDetails/widgets/imgWidget.dart';

enum ProgressState{
  idle,loading,buffering,ready,completed
}


class AudioPlayerClass extends StatefulWidget {

  final Book book;

  const AudioPlayerClass({Key? key, required this.book,}) : super(key: key);
  @override
  State<AudioPlayerClass> createState() => _AudioPlayerClassState();
}


class _AudioPlayerClassState extends State<AudioPlayerClass> {

   Timer? timer;
  @override
  void initState(){
    if(nowPlayingBook != pageManager.book){
      pageManager.setBook(widget.book);
    }


    super.initState();

  }


 void startTimer() {
   const oneSec = Duration(seconds: 1);
   timer = Timer.periodic(
     oneSec,
         (Timer timer) {
       if (StaticValue.sleepTimer == 0) {

         setState(() {
           pageManager.pause();
           timer.cancel();

         });
       } else {
         setState(() {
           StaticValue.sleepTimer--;
         });
       }
     },
   );
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
                onPressed: (){
                  if(pageManager.progressNotifier.value.current.inSeconds > StaticValue.skipAmount) {
                    pageManager.seek(Duration(
                        seconds: pageManager.progressNotifier.value.current
                            .inSeconds - StaticValue.skipAmount.toInt()));
                  }else{
                    pageManager.seek(const Duration(
                        seconds: 0));
                  }
                },
                icon:const Icon(Icons.fast_rewind_rounded,),
              ),
              // Expanded(child: Container(),flex: 2,),
              PlayButton(book: widget.book,timer: timer,startTimer: startTimer),
              // Expanded(child: Container(),flex: 2,),
              IconButton(
                iconSize: 40,
                color: Colors.indigo,
                onPressed: (){
                  if(pageManager.progressNotifier.value.current.inSeconds + StaticValue.skipAmount < pageManager.progressNotifier.value.total.inSeconds) {
                    pageManager.seek(Duration(seconds:pageManager.progressNotifier.value.current.inSeconds+StaticValue.skipAmount.toInt()));
                  }else{
                    pageManager.seek(Duration(seconds:pageManager.progressNotifier.value.total.inSeconds));
                  }

                },
                icon:const Icon(Icons.fast_forward_rounded),
              ),

              IconButton(
                iconSize: 30,
                color: Colors.grey,
                onPressed: (){

                  if(StaticValue.sleepTimer == 0) {
                    sleepBottomSheet(context: context).then((value) {
                      if (value != null) {
                        StaticValue.sleepTimer = value*60;
                      }
                      if (kDebugMode) {
                        print("$value min");
                      }

                      setState(() {});
                    });
                  }else{

                    setState(() {
                      StaticValue.sleepTimer = 0;
                    });
                  }
                },
                icon: Stack(
                 alignment: Alignment.topRight,
                  children:  [
                    const Icon(Icons.dark_mode_rounded,),
                    if(StaticValue.sleepTimer != 0 )  const Icon(Icons.close,size: 15),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),

      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
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

              title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: (){

                    sliderDialog(context: context, min: 0.5, max: 3, value: StaticValue.speed, changeText: "Set Speed",div: 10).then((value) {


                      if(value != null){
                        StaticValue.speed = value;
                        pageManager.setSpeed(value);
                      }
                      if (kDebugMode) {
                        print(value);
                      }
                    });
                  }, icon: const Icon(Icons.speed_rounded,color: Colors.grey,)),
                  // IconButton(onPressed: (){}, icon: Icon(Icons.fast_rewind_outlined,color: Colors.grey,)),
                  IconButton(onPressed: (){
                    sliderDialog(context: context, min: 2, max: 60, value: StaticValue.skipAmount, changeText: "Skip amount",div: 58).then((value) {

                      if(value != null){
                        StaticValue.skipAmount = value;
                      }
                      if (kDebugMode) {
                        print(StaticValue.skipAmount);
                      }
                    });
                  }, icon: const Icon(Icons.timelapse,color: Colors.grey,)),
                ],
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
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      imageWid(size*1.15,context,widget.book,false),
                      if(StaticValue.sleepTimer != 0) Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(

                            height: 40,
                            width: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.black26
                            ),
                            child: Center(
                                child: Text(

                                  // StaticValue.sleepTimer.toString()
                                   Duration(seconds: StaticValue.sleepTimer).toString()
                                      .substring(0,Duration(seconds: StaticValue.sleepTimer).toString().length -7)
                                  ,style: const TextStyle(color: Colors.white,fontSize: 16),)),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10,0,10,0),
                    child: Text(
                        widget.book.getBookName(),
                        style:  TextStyle( fontSize: 25,fontWeight: FontWeight.w500,
                            shadows: [Shadow(color: Colors.grey.shade50,offset: const Offset(0, 0),blurRadius: 3)]
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.center
                    ),
                  ),

                  const SizedBox(height: 1.618,),
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
              child: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: (){
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
  final Timer? timer;
  final Function startTimer;
  const PlayButton({Key? key,required this.book,required this.timer,required this.startTimer}) : super(key: key);
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
                  onPressed: (){pageManager.play(context);},
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
              onPressed: (){
                if(StaticValue.sleepTimer != 0){
                  startTimer();
                }
                pageManager.play(context);
                },
              color: Colors.indigo,
              child: const Icon(
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

              if(StaticValue.sleepTimer != 0){

              }
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