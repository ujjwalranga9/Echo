import 'dart:io';
import 'package:echo/Theme/darkTheme.dart';
import 'package:echo/Theme/lightTheme.dart';
import 'package:echo/bloc/grid_list_cubit.dart';
import 'package:echo/bloc/miniPlayerBloc.dart';
import 'package:echo/player/audioService/service_locator.dart';
import 'package:echo/player/page_manager.dart';
import 'package:echo/repository/localdata.dart';
import 'package:echo/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:path_provider/path_provider.dart';
import 'bloc/book_state_bloc.dart';
import 'bloc/localRepositoryBloc.dart';
import 'class/book.dart';
import 'dart:developer' as d;

late PageManager pageManager;
late Book nowPlayingBook;
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
  Bloc.observer = AppBlocObserver();
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
    LocalRepository localRepository = LocalRepository();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<LocalRepository>(create: (context) => localRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<GridListCubit>(create: (context)=>GridListCubit()),
          BlocProvider<BookStateCubit>(create: (context)=>BookStateCubit()),
          BlocProvider<MiniPlayerBloc>(create: (context)=>MiniPlayerBloc()),
          BlocProvider<LocalRepositoryBloc>(create: (context)=> LocalRepositoryBloc(localRepository)),
        ],
        child: MaterialApp(

          title: 'ECHO',
          theme: lightTheme(),
          darkTheme: darkTheme(),
          initialRoute: "/",
          onGenerateRoute: _appRouter.onGenerateRoute,
          debugShowCheckedModeBanner: false,

        ),
      ),
    );
  }
}



class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    print(bloc);
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print(bloc);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    print(bloc);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    print(error);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (bloc is Cubit) print(change);
  }
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}