import 'dart:io';
import 'package:echo/Theme/darkTheme.dart';
import 'package:echo/Theme/lightTheme.dart';
import 'package:echo/bloc/grid_list_cubit.dart';
import 'package:echo/player/audioService/service_locator.dart';
import 'package:echo/player/page_manager.dart';
import 'package:echo/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'class/book.dart';
import 'dart:developer' as d;

late PageManager pageManager;
late Directory directory;
late Directory externalDirectory;

bool timing = false;
bool sortByLength = true;


Future<void> main() async {
  
  d.log('App started running ...', name: 'main.dart');
  WidgetsFlutterBinding.ensureInitialized();
  directory = await getApplicationDocumentsDirectory();
  externalDirectory = Directory("/storage/emulated/0/Audiobooks");
  bool hasExisted = await externalDirectory.exists();
  if (!hasExisted) {
    externalDirectory.create();
    d.log('Going to Create Directory ...', name: 'main.dart');
    print(externalDirectory);
  }else{
    d.log('Going in the Audiobooks Directory ...', name: 'main.dart');
  }

  Hive.init(directory.path);
  Hive.registerAdapter<Book>(BookAdapter());

  await Hive.openBox<Book>('Books');
  await Hive.openBox<Book>('play');
  await Hive.openBox<Book>('Lib');
  await Hive.openBox<Book>('toRead');
  await Hive.openBox<Book>('current');
  await Hive.openBox<Book>('done');


  await setupServiceLocator();
  runApp(const MyApp());

}

class MyApp extends StatefulWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppRouter _appRouter = AppRouter();

  @override
  void dispose(){
    d.log('Dispose is called', name: 'main.dart',);
    _appRouter.dispose();
    var box =  Hive.box<Book>('play');
    box.putAt(0, pageManager.book);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_)=>GridListCubit()),
      ],
      child: MaterialApp(

        title: 'ECHO',
        theme: lightTheme(),
        darkTheme: darkTheme(),
        initialRoute: "/",
        onGenerateRoute: _appRouter.onGenerateRoute,
        debugShowCheckedModeBanner: false,

      ),
    );
  }
}
