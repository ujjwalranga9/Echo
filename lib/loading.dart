import 'package:echo/widgets/libraryView.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

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
      LibraryView.listView = listview;
    }
    if(time != null){
      timing = time;
    }

    Navigator.pushReplacementNamed(context,'/home');
  }

  @override
  void initState(){
    super.initState();
    sett();

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
