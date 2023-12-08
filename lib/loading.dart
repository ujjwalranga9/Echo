import 'package:echo/player/page_manager.dart';
import 'package:echo/widgets/libraryView.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'class/book.dart';
import 'main.dart';
import 'dart:developer' as d;

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  Future<void> sett() async {
    final Future<SharedPreferences> pref = SharedPreferences.getInstance();

    final SharedPreferences prefs = await pref;

    bool? listview = prefs.getBool('listview');
    bool? time = prefs.getBool('timing');
    if(listview != null){
      d.log('LibraryView.listView initialized', name: 'loading.dart',);
      LibraryView.listView = listview;
    }
    if(time != null){
      d.log('timing initialized', name: 'loading.dart',);
      timing = time;
    }

    if(prefs.getBool("SortLen") == null){
      sortByLength = false;
    }else{
      d.log('SortLen initialized', name: 'loading.dart',);
      sortByLength = prefs.getBool("SortLen")!;
    }
  }

  @override
  void initState(){
    d.log('Loading Init is called', name: 'loading.dart',);
    super.initState();
    sett();
    var box =  Hive.box<Book>('play');
    if(box.isNotEmpty){
      d.log('AudioLib not Empty', name: 'main.dart',);
      pageManager = PageManager(box.getAt(0)!);

    }else{
      d.log('AudioLib is Empty', name: 'main.dart',);
      Book b = Book(
        id: '1',
        title: "Ego is the Enemy",
        imageUrl: 'https://dailyaudiobooks.b-cdn.net/wp-content/uploads/2022/06/41gED2-t4oL._SX352_BO1204203200.jpg',
        audio: ['https://ipaudio.club/wp-content/uploads/PRIME/Ego%20Is%20the%20Enemy/02.mp3'],
      );
      pageManager = PageManager(b);
    }
    d.log('Homepage is called', name: 'loading.dart',);
    Future.delayed(Duration.zero,
    () {
      Navigator.pushReplacementNamed(context,'/home');
    },);


  }

  @override
  Widget build(BuildContext context) {
    return  const Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: CircularProgressIndicator(

      ),),
    );
  }
}
