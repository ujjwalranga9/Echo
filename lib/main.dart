import 'dart:io';
import 'package:echo/Theme/darkTheme.dart';
import 'package:echo/Theme/lightTheme.dart';
import 'package:echo/player/audioService/service_locator.dart';
import 'package:echo/player/notifier/play_button_notifier.dart';
import 'package:echo/player/page_manager.dart';
import 'package:echo/screens/library/library.dart';
import 'package:echo/search.dart';
import 'package:echo/settings.dart';
import 'package:echo/widgets/currentlyReading.dart';
import 'package:echo/widgets/doneReading.dart';
import 'package:echo/widgets/libraryView.dart';
import 'package:echo/widgets/toRead.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'cal.dart';
import 'class/book.dart';
import 'loading.dart';


late PageManager pageManager;

late Directory directory;
late Directory externalDirectory;

bool timing = false;
bool sortByLength = true;

Future<void> main() async {



  // await audio_service.init(
  //   androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
  //   androidNotificationChannelName: 'Audio playback',
  //   androidNotificationOngoing: true,
  // );

  WidgetsFlutterBinding.ensureInitialized();
  directory = await getApplicationDocumentsDirectory();
  externalDirectory = (await getExternalStorageDirectory())!;

  Hive.init(directory.path);
  Hive.registerAdapter<Book>(BookAdapter());

  await Hive.openBox<Book>('Books');
  await Hive.openBox<Book>('play');
  await Hive.openBox<Book>('Lib');
  await Hive.openBox<Book>('toRead');
  await Hive.openBox<Book>('current');
  await Hive.openBox<Book>('done');
  final prefs = await SharedPreferences.getInstance();
  sortByLength = prefs.getBool("SortLen")!;
  await setupServiceLocator();
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      title: 'ECHO',

      theme: lightTheme(),
      darkTheme: darkTheme(),
      // theme: ThemeData(
      //
      //
      //
      //   appBarTheme: const AppBarTheme(
      //
      //     systemOverlayStyle: SystemUiOverlayStyle(
      //         statusBarColor: Colors.black,
      //         statusBarIconBrightness: Brightness.light
      //     ),
      //   ),
      //
      //   primarySwatch: Colors.purple,
      //
      // ),

      initialRoute: '/',
      routes: {
        '/' : (context)=>const Loading(),
        '/home' : (context)=>const HomePage(),
      },

      debugShowCheckedModeBanner: false,


    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static int state = 1;

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin<HomePage> {



  @override
  void initState(){


    // var bo =  Hive.box<Book>('Lib');
    //
    // for(int i = 0 ;  i < bo.length ; i++){
    //   print('${bo.getAt(i)!.duration.length}     ${bo.getAt(i)!.getBookName()}   ${bo.getAt(i)!.getAuthor()}     index: $i');
    //
    // }


    var box =  Hive.box<Book>('play');
    if(box.isNotEmpty){
      pageManager = PageManager(box.getAt(0)!);

    }else{
      Book b = Book(
          id: '1',
          title: "Add a Book",
          imageUrl: 'a',
          audio: ['1'],
      );

      pageManager = PageManager(b);

    }

    getIt<PageManager>().init();

    // controller = TabController(length: 3, vsync: this,initialIndex: HomePage.state);
    // controller.addListener(() {
    //   HomePage.state = controller.index;
    // });
    super.initState();
  }


  void bigState(){
    setState(() {
    });
  }
  @override
  void dispose() {
    // controller.dispose();
    super.dispose();
  }
  bool isPlaying = false;
  // late TabController controller;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      animationDuration: const Duration(milliseconds: 500),
      child: Scaffold(
        backgroundColor: Colors.white,

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

        

        bottomNavigationBar: Container(

          padding: const EdgeInsets.only(left: 30,right: 30,bottom: 10),
          child: Container(

            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                // boxShadow: [BoxShadow(color: Colors.grey.shade300,blurRadius: 10,blurStyle: BlurStyle.normal)],
                color: Colors.white
            ),
            height: 80,
            child: TabBar(

              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorWeight: 0.1,
              splashBorderRadius: BorderRadius.circular(40),



              // tabs: const [
              //   Tab(text: "To Listen",icon: Icon(Icons.list_rounded,),),
              //   Tab(text: "Listening",icon: Icon(Icons.chrome_reader_mode_rounded)),
              //   Tab(text: "Completed",icon: Icon(Icons.done_all_rounded),)
              // ],

              tabs: const [
                Tab(icon: Icon(Icons.list_rounded,),),
                Tab(icon: Icon(Icons.chrome_reader_mode_rounded)),
                Tab(icon: Icon(Icons.done_all_rounded),)
              ],

            ),
          ),
        ),
        extendBody: true,
        extendBodyBehindAppBar: true,



        appBar: AppBar(

          title: const Text(
            "ECHO",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 23,
                letterSpacing: 3
            ),
          ),

          backgroundColor: Colors.blue.shade50,

          actions: [
            IconButton(onPressed: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx){
                    return  Lib();
                  })
              );
            },
              icon: const Icon(
                  Icons.library_books),
              splashRadius: 20,),


            IconButton(onPressed: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx){
                  return  Search(update: bigState);
                })
              );
            },
              icon: const Icon(
                  Icons.search_rounded ),
              splashRadius: 20,),

            IconButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('listview', !LibraryView.listView);
              setState((){
                LibraryView.listView = ! LibraryView.listView;
              });

              },
              icon: Icon(
                  (LibraryView.listView == true)
                      ? Icons.grid_view_rounded
                      : Icons.format_list_bulleted_rounded ),
              splashRadius: 20,
            ),

            IconButton(
              onPressed: (){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx){
                      return Settings(fun: bigState);
                    })
                );
              },
              icon: const Icon( Icons.settings_rounded),
              splashRadius: 20,
            ),


          ],
        ),



      body:const TabBarView(
        // controller: controller,


        children: [
           Padding(
            padding: EdgeInsets.all(10),
            child:ToRead(),
          ),

           Padding(
            padding: EdgeInsets.all(10),
            child: CurrentRead(),
          ),

          Padding(
            padding: EdgeInsets.all(10),
            child: DoneReading(),
          ),
        ],
      ),

        // Padding(
        //   padding: EdgeInsets.all(10),
        //   child: LibraryView(state: state,),
        // ),




      // floatingActionButton: FloatingActionButton(
      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      //   splashColor: const Color(0x256E0097),
      //   onPressed: ()  {
      //     if(isPlaying){
      //       pageManager.pause();
      //       setState((){
      //         isPlaying = false;
      //       });
      //     }else{
      //       var book = Hive.box<Book>('play').getAt(0);
      //       var seek =book?.parseDuration(book.position[0]);
      //       pageManager.seek(seek!);
      //       pageManager.play();
      //       setState((){
      //         isPlaying = true;
      //       });
      //     }
      //   },
      //   backgroundColor: const Color(0xff6E0097),
      //   child: const PlayButton(),
      // ),

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
                  color: Colors.white,splashRadius: 20,
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