import 'dart:io';
import 'package:echo/player/audioService/service_locator.dart';
import 'package:echo/player/notifier/play_button_notifier.dart';
import 'package:echo/player/page_manager.dart';
import 'package:echo/search.dart';
import 'package:echo/settings.dart';
import 'package:echo/widgets/libraryView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'class/book.dart';
import 'loading.dart';
import 'package:audio_service/audio_service.dart';


late PageManager pageManager;

late Directory directory;
late Directory externalDirectory;

bool timing = false;

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
  await Hive.openBox<Book>('temp');
  await setupServiceLocator();
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      title: 'ECHO',

      theme: ThemeData(



        appBarTheme: const AppBarTheme(

          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.black,
              statusBarIconBrightness: Brightness.light
          ),
        ),

        primarySwatch: Colors.purple,

      ),

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

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {



  @override
  void initState(){

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


    super.initState();
  }

  void bigState(){
    setState(() {

    });
  }

  bool isPlaying = false;
  int state = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      bottomNavigationBar: Container(
        height: 50,
        child: GNav(
          selectedIndex: 1,
         // rippleColor: Colors.grey[800], // tab button ripple color when pressed
         // hoverColor: Colors.grey[700], // tab button hover color
          haptic: true, // haptic feedback
          tabBorderRadius: 20,
          tabActiveBorder: Border.all(color: Colors.black, width: 1), // tab button border
          //tabBorder: Border.all(color: Colors.grey, width: 1), // tab button border
          //tabShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 8)], // tab button shadow
         // curve: Curves.easeOutExpo, // tab animation curves
          //duration: Duration(milliseconds: 900), // tab animation duration
          gap: 8, // the tab button gap between icon and text
          color: Colors.grey[600], // unselected icon color
          activeColor: Colors.purple, // selected icon and text color
          iconSize: 25, // tab button icon size
          tabBackgroundColor: Colors.purple.withOpacity(0.1), // selected tab background color
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          onTabChange: (index){
            state = index;
          },

          tabs:    [
            GButton(
              icon: Icons.list_rounded,
              text: 'To Read',
              onPressed: (){
                setState(() {

                });
              },


            ),
            GButton(
              icon: Icons.chrome_reader_mode_rounded,
              text: 'Currently reading',
              onPressed: (){
                setState(() {
                });
              },

            ),
            GButton(
              icon: Icons.done_all_rounded,
              text: 'Completed',
              onPressed: (){
                setState(() {

                });
              },

            ),
          ],
        ),
      ),

      appBar: AppBar(

        title: const Text(
          "ECHO",
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 23,
              letterSpacing: 3
          ),
        ),

        backgroundColor: Colors.black,

        actions: [
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
                    return const Settings();
                  })
              );
            },
            icon: const Icon( Icons.settings_rounded),
            splashRadius: 20,
          ),


        ],
      ),



    body:
    // DefaultTabController(
      // length: 3,
      // child: tabs(),

      Padding(
        padding: EdgeInsets.all(10),
        child: LibraryView(state: state,),
      ),

    // ),


    floatingActionButton: FloatingActionButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      splashColor: const Color(0x256E0097),
      onPressed: ()  {
        if(isPlaying){
          audioHandler.pause();
          setState((){
            isPlaying = false;
          });
        }else{
          var book = Hive.box<Book>('play').getAt(0);
          var seek =book?.parseDuration(book.position[0]);
          audioHandler.seek(seek!);
          audioHandler.play();
          setState((){
            isPlaying = true;
          });
        }
      },
      backgroundColor: const Color(0xff6E0097),
      child: PlayButton(),
    ),

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
            return IconButton(
                  color: Colors.white,splashRadius: 20,
                  icon: const Icon(Icons.play_arrow_rounded),
                  onPressed: audioHandler.play,
            );
          case ButtonState.paused:
            return IconButton(
              color: Colors.white,splashRadius: 20,
              icon: const Icon(Icons.play_arrow_rounded),

              onPressed: audioHandler.play,
            );
          case ButtonState.playing:
            return IconButton(
              color: Colors.white,splashRadius: 20,
              icon: const Icon(Icons.pause_rounded),
              onPressed: audioHandler.pause,
            );
        }
      },
    );
  }
}

Widget tabs(){
  return TabBar(

      tabs: [

    TabBarView(
      children: [Padding(
        padding: EdgeInsets.all(10),
        child: LibraryView(state: 0,),
      ),
      ],
    ),

        TabBarView(
          children: [Padding(
            padding: EdgeInsets.all(10),
            child: LibraryView(state: 1,),
          ),
          ],
        ),

        TabBarView(
          children: [Padding(
            padding: EdgeInsets.all(10),
            child: LibraryView(state: 2,),
          ),
          ],
        ),
  ]);

}