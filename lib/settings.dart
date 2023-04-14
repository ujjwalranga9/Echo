import 'package:echo/main.dart';
import 'package:echo/widgets/libraryView.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool audioTime = true;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text(
          "Settings",
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 23,
              letterSpacing: 3
          ),
        ),

        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: CheckboxListTile(
                  tileColor: Color(0xff202020),

                  title: const Text("Show Audio Length",style: TextStyle(
                    color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                     // letterSpacing: 3
                  ),),
                  value: timing,
                  onChanged: (val) async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('timing', !timing);
                    setState((){
                      timing  = !timing;
                    });
                    print(timing);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: CheckboxListTile(
                  tileColor: Color(0xff202020),

                  title: const Text("Library ListView",style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    fontSize: 20,
                    // letterSpacing: 3
                  ),),
                  value: LibraryView.listView,
                  onChanged: (val){
                    setState((){
                      LibraryView.listView  = !LibraryView.listView;
                    });
                    print(LibraryView.listView);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
