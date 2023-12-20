import 'package:echo/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  Settings({Key? key,required this.fun}) : super(key: key);
  Function fun;
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool audioTime = true;


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.fun();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(

          title: const Text(
            "Settings",
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 23,
                letterSpacing: 3
            ),
          ),

          backgroundColor: Colors.blue.shade50,
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: CheckboxListTile(
                    tileColor: Theme.of(context).errorColor,

                    title:  Text("Show Audio Length",style: TextStyle(
                      color: Theme.of(context).textTheme.titleMedium?.color,
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                       // letterSpacing: 3
                    ),),
                    value: timing,
                    activeColor: Colors.black,
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
                // Padding(
                //   padding: const EdgeInsets.all(10),
                //   child: CheckboxListTile(
                //     tileColor: Theme.of(context).errorColor,
                //
                //     title:  Text("Library ListView",style: TextStyle(
                //       color: Theme.of(context).textTheme.titleMedium?.color,
                //       fontWeight: FontWeight.w400,
                //       fontSize: 20,
                //       // letterSpacing: 3
                //     ),),
                //     activeColor: Colors.black,
                //     value:
                //     onChanged: (val){
                //
                //       });
                //
                //     },
                //   ),
                // ),

                Padding(
                  padding: const EdgeInsets.all(10),
                  child: CheckboxListTile(
                    tileColor: Theme.of(context).errorColor,
                    activeColor: Colors.black,

                    title:  Text("Sort by Size",style: TextStyle(
                      color: Theme.of(context).textTheme.titleMedium?.color,
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      // letterSpacing: 3
                    ),),
                    value: sortByLength,
                    onChanged: (val) async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('SortLen', !sortByLength);
                      setState((){
                        sortByLength  = val!;
                        widget.fun();
                      });
                      print(sortByLength);
                    },
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
