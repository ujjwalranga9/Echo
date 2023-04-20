import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:echo/player/notifier/play_button_notifier.dart';
import 'package:echo/player/notifier/progress_notifier.dart';
import 'package:echo/services/download.dart';
import 'package:echo/widgets/imageWidget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'class/book.dart';
import 'main.dart';

enum ProgressState{
  idle,loading,buffering,ready,completed
}

class AudioPlayerPage extends StatefulWidget {

  static int audioFileNo = -1;
  final Book book;
  bool saved;
  static List<String> oldPosition =[];
   AudioPlayerPage({Key? key, required this.book,required this.saved}) : super(key: key);
  @override
  State<AudioPlayerPage> createState() => _AudioPlayerPageState();
}


class _AudioPlayerPageState extends State<AudioPlayerPage> {


  @override
  void initState(){

    var box =  Hive.box<Book>('play');
    if(box.isNotEmpty && box.getAt(0) != widget.book){
      box.clear();
      box.add(widget.book);
    }else{
      box.add(widget.book);
    }

    if(AudioPlayerPage.audioFileNo != -1 ){
      if(downloaded("${widget.book.title}_${AudioPlayerPage.audioFileNo}")){
        pageManager.setAsset("${widget.book.title}_${AudioPlayerPage.audioFileNo}");
      }else{
        pageManager.setUrl(widget.book.audio[ AudioPlayerPage.audioFileNo]);
      }


    }else{
      AudioPlayerPage.audioFileNo = 0;
      pageManager.setBook(widget.book);
    }

    if(widget.saved) {
      Future.delayed(const Duration(seconds: 0, milliseconds: 500)).then((
          value) => seekOld());
    }else {
      Future.delayed(const Duration(seconds: 2, milliseconds: 0)).then((
          value) => seekOld());
    }



    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   seekOld();
    //   setState(() {});
    //   print("\n\n\n\nBuild Completed");
    // });


    // if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.persistentCallbacks) {
    //   SchedulerBinding.instance.addPostFrameCallback((_) {
    //     seekOld();
    //     setState(() {});
    //   });
    // }
  }

  @override
  void dispose(){

    super.dispose();
  }



  void seekOld(){
    pageManager.seek(widget.book.parseDuration(AudioPlayerPage.oldPosition[AudioPlayerPage.audioFileNo]));
  }

  Duration seekValue = const Duration(seconds: 5);
  double speed = 1.0;

  @override
  Widget build(BuildContext context){

    var val = MediaQuery.of(context).size;


    return Scaffold(

      backgroundColor: Colors.black,

      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround ,
          children: [
            SizedBox(height: val.height*0.03,),
            SizedBox(
              height: val.height*0.7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: val.height*0.09,),
                  Expanded(
                    child: Center(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ImageWidget(width: 300,book: widget.book,),
                              Container(
                                width: 300,
                                decoration: BoxDecoration(
                                     border: Border.all(width: 5,color: Colors.black),
                                     borderRadius: BorderRadius.circular(10)
                                    ),
                                  )

                            ],
                          )
                      ),
                    ),
                  ),
                  SizedBox(height: val.height*0.02,),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: FittedBox(child: Text(widget.book.getBookName(),style: const TextStyle(color:Colors.white,fontSize: 45,fontWeight: FontWeight.bold),)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: FittedBox(child: Text(widget.book.getAuthor(),style: const TextStyle(color:Colors.white,fontSize: 15,),)),
                  ),
                ],
              ),
            ),
            SizedBox(height: val.height*0.02,),
            SizedBox(
              height: val.height*0.2,
              child: Column(
                children: [

                  Padding(
                        padding: const EdgeInsets.only(left: 20,right: 20),
                              child: AudioProgressBar(book: widget.book),
                           ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 10,),
                      IconButton(
                        iconSize: 25,
                        color: Colors.white,
                        onPressed: seekOld,
                        // onPressed: (){
                        //   print("\n");
                        //   print(widget.book.parseDuration(AudioPlayerPage.oldPosition[AudioPlayerPage.audioFileNo]));
                        //   print("\n");
                        //   pageManager.seek(widget.book.parseDuration(AudioPlayerPage.oldPosition[AudioPlayerPage.audioFileNo]));
                        // },
                        icon:const Icon(Icons.bookmark,),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                        iconSize: 50,
                        color: Colors.white,
                        onPressed: (){

                          setState(() {
                            if(pageManager.progressNotifier.value.current < seekValue){
                              pageManager.seek( const Duration(seconds: 0));
                            }else{
                              pageManager.seek( Duration(seconds: pageManager.progressNotifier.value.current.inSeconds -seekValue.inSeconds));
                            }
                          });
                        },
                        icon:const Icon(Icons.fast_rewind_rounded,),
                      ),
                      const PlayButton(),
                      IconButton(
                        iconSize: 50,
                        color: Colors.white,
                        onPressed: (){
                          setState(()  {
                            if(pageManager.progressNotifier.value.current >  Duration(seconds: pageManager.progressNotifier.value.total.inSeconds -seekValue.inSeconds)){

                              pageManager.seek( Duration(seconds: pageManager.progressNotifier.value.total.inSeconds));
                            }else{
                              pageManager.seek( Duration(seconds: pageManager.progressNotifier.value.current.inSeconds +seekValue.inSeconds));
                            }
                          });
                        },
                        icon:const Icon(Icons.fast_forward_rounded),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                        iconSize: 25,
                        color: Colors.white,
                        onPressed: (){
                          showDialog(context: context, builder: (ctx){
                            return  StatefulBuilder(
                            builder: (context, setState) {
                              return
                                AlertDialog(
                                backgroundColor: const Color(0xff101010),
                                title:const Center(child:  Text("Adjust Speed",style: TextStyle(color: Colors.white,fontSize: 20),)),
                                content: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    TextButton(onPressed: (){
                                      if(speed < 0.5)return;
                                      setState((){
                                        speed -= 0.1;
                                        pageManager.setSpeed(speed);
                                      });
                                    },child: const Text("-",style: TextStyle(color: Colors.white,fontSize: 20),) ,),
                                    Text(speed.toStringAsFixed(1),style:const  TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                                    TextButton(onPressed: (){
                                      if(speed > 3.0)return;
                                      setState((){
                                        speed += 0.1;
                                        pageManager.setSpeed(speed);
                                      });
                                    },child: const Text("+",style: TextStyle(color: Colors.white,fontSize: 20),) ,),
                                  ],
                                ),
                              );
                          }
                          );
                          });
                        },
                        icon:const Icon(Icons.speed,),
                      ),
                      const SizedBox(width: 10,),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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


        if(value.current == Duration(hours: value.total.inHours , minutes: value.total.inMinutes , seconds: value.total.inSeconds)){
           if(book.audio.length > AudioPlayerPage.audioFileNo) AudioPlayerPage.audioFileNo++;

             book.position[AudioPlayerPage.audioFileNo] = value.total.toString();

        }else{
          book.position[AudioPlayerPage.audioFileNo] = value.current.toString();
        }
        Hive.box<Book>("Lib").put(book.getBookName() + book.id, book);


        return ProgressBar(
          timeLabelTextStyle: const TextStyle(color: Colors.white),
          timeLabelPadding: 8,
          progressBarColor: Theme.of(context).primaryColor,
          baseBarColor: Colors.white.withOpacity(0.24),
          bufferedBarColor: Theme.of(context).primaryColor.withOpacity(0.24),
          thumbColor: Colors.white,
          progress: value.current,
          buffered: value.buffered,
          total: value.total,
          onSeek: pageManager.seek,
        );
      },
    );
  }
}


class PlayButton extends StatelessWidget {
  const PlayButton({Key? key}) : super(key: key);
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
                IconButton(
                color: Colors.white,
                icon: const Icon(Icons.play_circle_rounded),
                splashRadius: 20,
                iconSize: 70,
                onPressed: pageManager.play,
              ),
                SizedBox(
                    height: 70,
                    width: 70,
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      color: Theme.of(context).primaryColor,
                    )),
              ],
            );
          case ButtonState.paused:
            return IconButton(
              color: Colors.white,
              icon: const Icon(Icons.play_circle_rounded),
              iconSize: 70,
              splashRadius: 20,
              onPressed: pageManager.play,
            );
          case ButtonState.playing:
            return IconButton(
              color: Colors.white,
              icon: const Icon(Icons.pause_circle_rounded),
              splashRadius: 20,
              iconSize: 70,
              onPressed: pageManager.pause,
            );
        }
      },
    );
  }
}