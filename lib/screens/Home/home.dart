
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../class/book.dart';
import '../../main.dart';
import '../../player/notifier/play_button_notifier.dart';
import '../../widgets/currentlyReading.dart';
import '../../widgets/doneReading.dart';
import '../../widgets/libraryView.dart';
import '../../widgets/toRead.dart';
import 'dart:developer' as d;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static int state = 1;

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin<HomePage> {

  @override
  void initState(){
    d.log('Homepage Init is called', name: 'home.dart',);
    super.initState();
  }

  void bigState(){
    setState(() {});
  }


  bool isPlaying = false;
  double imageHeight  = 200;
  double imageWidth = 200;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    super.build(context);

    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      animationDuration: const Duration(milliseconds: 500),
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,

        // bottomNavigationBar: Container(
        //   height: 50,
        //   child: GNav(
        //     selectedIndex: 1,
        //    // rippleColor: Colors.grey[800], // tab button ripple color when pressed
        //    // hoverColor: Colors.grey[700], // tab button hover color
        //     haptic: true, // haptic feedback
        //     tabBorderRadius: 20,
        //     tabActiveBorder: Border.all(color: Colors.black, width: 1), // tab button border
        //     //tabBorder: Border.all(color: Colors.grey, width: 1), // tab button border
        //     //tabShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 8)], // tab button shadow
        //    // curve: Curves.easeOutExpo, // tab animation curves
        //     //duration: Duration(milliseconds: 900), // tab animation duration
        //     gap: 8, // the tab button gap between icon and text
        //     color: Colors.grey[600], // unselected icon color
        //     activeColor: Colors.purple, // selected icon and text color
        //     iconSize: 25, // tab button icon size
        //     tabBackgroundColor: Colors.purple.withOpacity(0.1), // selected tab background color
        //     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //     onTabChange: (index){
        //
        //       setState(() {
        //         HomePage.state = index;
        //
        //       });
        //       controller.animateTo(HomePage.state);
        //     },
        //
        //
        //     tabs:     [
        //
        //       GButton(
        //         icon: Icons.list_rounded,
        //         text: 'To Read',
        //         onPressed: (){
        //
        //           setState(() {
        //
        //             controller.animateTo(HomePage.state);
        //
        //           });
        //
        //         },
        //
        //
        //       ),
        //       GButton(
        //         icon: Icons.chrome_reader_mode_rounded,
        //         text: 'Currently reading',
        //         onPressed: (){
        //
        //           setState(() {
        //
        //
        //             controller.animateTo(HomePage.state);
        //           });
        //
        //
        //         },
        //
        //       ),
        //       GButton(
        //         icon: Icons.done_all_rounded,
        //         text: 'Completed',
        //         onPressed: (){
        //
        //           setState(() {
        //             controller.animateTo(2);
        //           });
        //
        //         },
        //
        //       ),
        //     ],
        //   ),
        // ),



        // bottomNavigationBar: Container(
        //   color: Colors.transparent,
        //   padding: const EdgeInsets.only(left: 30,right: 30,bottom: 10),
        //   child: Container(
        //
        //     decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(20),
        //         // boxShadow: [BoxShadow(color: Colors.grey.shade300,blurRadius: 10,blurStyle: BlurStyle.normal)],
        //         color: Colors.blue.shade50
        //     ),
        //     height: 60,
        //
        //     child: TabBar(
        //
        //       labelColor: Theme.of(context).primaryColor,
        //       unselectedLabelColor: Colors.black45,
        //       indicatorWeight: 0.1,
        //       splashBorderRadius: BorderRadius.circular(40),
        //
        //
        //
        //       // tabs: const [
        //       //   Tab(text: "To Listen",icon: Icon(Icons.list_rounded,),),
        //       //   Tab(text: "Listening",icon: Icon(Icons.chrome_reader_mode_rounded)),
        //       //   Tab(text: "Completed",icon: Icon(Icons.done_all_rounded),)
        //       // ],
        //
        //       tabs: const [
        //         Tab(icon: Icon(Icons.list_rounded,),),
        //         Tab(icon: Icon(Icons.chrome_reader_mode_rounded)),
        //         Tab(icon: Icon(Icons.done_all_rounded),)
        //       ],
        //
        //     ),
        //   ),
        // ),
        // extendBody: true,
        // extendBodyBehindAppBar: true,



        appBar: AppBar(

          title: const Text(
            "ECHO",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 23,
                letterSpacing: 3,

            ),
          ),

          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,

          actions: [
            IconButton(
              onPressed: (){
                d.log('Lib is called', name: 'home.dart',);
                Navigator.of(context).pushNamed("/lib");
              },
              icon: const Icon(
                  Icons.library_books),
              splashRadius: 20,),


            IconButton(
              onPressed: (){
                d.log('Search is called', name: 'home.dart',);
                Navigator.of(context).pushNamed("/search",arguments: bigState).then((value) {
                  setState(() {});
                });
              },
              icon: const Icon(
                  Icons.search_rounded ),
              splashRadius: 20,),

            // IconButton(
            //   onPressed: () async {
            //     final prefs = await SharedPreferences.getInstance();
            //     await prefs.setBool('listview', !LibraryView.listView);
            //   setState((){
            //     LibraryView.listView = ! LibraryView.listView;
            //   });
            //   },
            //   icon: Icon(
            //       (LibraryView.listView == true)
            //           ? Icons.grid_view_rounded
            //           : Icons.format_list_bulleted_rounded ),
            //   splashRadius: 20,
            // ),

            IconButton(
              onPressed: (){
                d.log('Setting is called', name: 'home.dart',);
                Navigator.of(context).pushNamed('/settings',arguments: bigState).then((value) {
                    Navigator.pop(context);
                    Navigator.of(context).pushNamed('/home');
                });




                // Navigator.of(context).push(
                //     MaterialPageRoute(builder: (ctx){
                //       return Settings(fun: bigState);
                //     })
                // ).then((value) {
                //   // setState(() {
                //   //
                //   // });
                //   Navigator.pop(context);  // pop current page
                //   Navigator.of(context).push(
                //       MaterialPageRoute(builder: (ctx){
                //         return HomePage();
                //       })
                //   );
                // });
              },
              icon: const Icon( Icons.settings_rounded),
              splashRadius: 20,
            ),
          ],
        ),


        body:Stack(
          alignment: Alignment.bottomCenter,
          children: [


            TabBarView(

              children: [
                // Padding(
                //  padding: EdgeInsets.all(10),
                //  child:
                ToRead(),
                // ),

                // Padding(
                //  padding: EdgeInsets.all(10),
                //  child:
                CurrentRead(),
                // ),

                // Padding(
                //   padding: EdgeInsets.all(10),
                //   child:
                DoneReading(),
                // ),
              ],
            ),

            // Container(
            //   decoration: const BoxDecoration(
            //     color: Colors.transparent,
            //   ),
            //
            //   padding: const EdgeInsets.only(bottom: 15,
            //     //  left: 15
            //   ),
            //   child: Container(
            //
            //     decoration: BoxDecoration(
            //
            //         boxShadow: const [BoxShadow(color: Colors.black26,blurRadius: 5,offset: Offset(0,1),blurStyle: BlurStyle.inner,)],
            //         borderRadius: BorderRadius.circular(20),
            //         // boxShadow: [BoxShadow(color: Colors.grey.shade300,blurRadius: 10,blurStyle: BlurStyle.normal)],
            //         color: Theme.of(context).appBarTheme.backgroundColor
            //     ),
            //     height: 58,
            //     width: 330,
            //
            //     child: TabBar(
            //
            //       labelColor: Theme.of(context).primaryColor,
            //       unselectedLabelColor: Theme.of(context).appBarTheme.foregroundColor?.withOpacity(0.5),
            //       indicatorWeight: 0.01,
            //       splashBorderRadius: BorderRadius.circular(40),
            //
            //
            //
            //
            //       // tabs: const [
            //       //   Tab(text: "To Listen",icon: Icon(Icons.list_rounded,),),
            //       //   Tab(text: "Listening",icon: Icon(Icons.chrome_reader_mode_rounded)),
            //       //   Tab(text: "Completed",icon: Icon(Icons.done_all_rounded),)
            //       // ],
            //
            //       tabs: const [
            //         Tab(icon: Icon(Icons.list_rounded,),),
            //         Tab(icon: Icon(Icons.chrome_reader_mode_rounded)),
            //         Tab(icon: Icon(Icons.done_all_rounded),)
            //       ],
            //
            //     ),
            //   ),
            // ),

            // Positioned(
            //   height: 200,
            //   bottom: 70,
            //   right: 1,
            //   left: 1,
            //   child: Padding(
            //     padding: const EdgeInsets.all(15),
            //     child: ClipRRect(
            //       borderRadius: BorderRadius.circular(20),
            //
            //      child: Image(
            //
            //        colorBlendMode: BlendMode.colorBurn,
            //        height:  imageHeight,
            //        width: imageWidth,
            //        fit: BoxFit.cover,
            //        image: NetworkToFileImage(
            //          url: pageManager.book.imageUrl,
            //          file: file(pageManager.book.getImage().substring(pageManager.book.getImage().lastIndexOf('/')+1,pageManager.book.getImage().length)),
            //          //debug: true,
            //        ),
            //        errorBuilder: (context, error, stackTrace) {
            //          return  Stack(
            //              alignment: Alignment.center,
            //              children: [
            //                Container(
            //                  width: imageWidth,
            //                  height: imageHeight,
            //                  color: const Color(0xff191919),
            //                ),
            //                Image.asset('audiobook.png',
            //                  fit: BoxFit.cover,
            //                  width: imageWidth,
            //                  height: imageHeight,
            //                ),
            //              ]);
            //        },
            //      ),
            //     ),
            //   ),
            // )
          ],
        ),





        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),

              padding: const EdgeInsets.only(
                // bottom: 15,
                 left: 30
              ),
              child: Container(

                decoration: BoxDecoration(
                    boxShadow: const [BoxShadow(color: Colors.black26,blurRadius: 5,offset: Offset(0,1),blurStyle: BlurStyle.inner,)],
                    borderRadius: BorderRadius.circular(20),
                    color: Theme.of(context).appBarTheme.backgroundColor
                ),
                height: 58,
                width: size.width*0.7,

                child: TabBar(

                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Theme.of(context).appBarTheme.foregroundColor?.withOpacity(0.5),
                  indicatorWeight: 0.01,
                  splashBorderRadius: BorderRadius.circular(40),

                  tabs: const [
                    Tab(icon: Icon(Icons.list_rounded,),),
                    Tab(icon: Icon(Icons.chrome_reader_mode_rounded)),
                    Tab(icon: Icon(Icons.done_all_rounded),)
                  ],

                ),
              ),
            ),

            FloatingActionButton(
              elevation: 2,

              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              splashColor: const Color(0x256E0097),
              onPressed: ()  {
                if(isPlaying){
                  pageManager.pause();
                  setState((){
                    isPlaying = false;
                  });
                }else{
                  var book = Hive.box<Book>('play').getAt(0);
                  var seek =book?.parseDuration(book.position[0]);
                  pageManager.seek(seek!);
                  pageManager.play();
                  setState((){
                    isPlaying = true;
                  });
                }
              },
              backgroundColor: const Color(0xff6E0097),
              child: const PlayButton(),
            ),
          ],
        ),

      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;


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
            return IconButton(
              color: Colors.white,
              splashRadius: 20,
              icon: const Icon(Icons.play_arrow_rounded),
              onPressed: pageManager.play,
            );
          case ButtonState.paused:
            return IconButton(
              color: Colors.white,splashRadius: 20,
              icon: const Icon(Icons.play_arrow_rounded),

              onPressed: pageManager.play,
            );
          case ButtonState.playing:
            return IconButton(
              color: Colors.white,splashRadius: 20,
              icon: const Icon(Icons.pause_rounded),
              onPressed: pageManager.pause,
            );
        }
      },
    );
  }
}

Widget tabs(){

  return TabBarView(


    children: [
      Padding(
        padding: const EdgeInsets.all(10),
        child: LibraryView(state: 0,),
      ),

      Padding(
        padding: const EdgeInsets.all(10),
        child: LibraryView(state: 1,),
      ),

      Padding(
        padding: const EdgeInsets.all(10),
        child: LibraryView(state: 2,),
      ),
    ],
  );

}