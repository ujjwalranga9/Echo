

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData lightTheme(){

  return ThemeData(
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Color(0xff6E0097),

    ),
    indicatorColor: Colors.black,
    accentColor: Colors.blue.shade50,
    iconTheme: const IconThemeData(
        color: Colors.black
    ),

  useMaterial3: true,
    appBarTheme:    AppBarTheme(
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.blue[50],
          statusBarIconBrightness: Brightness.dark
      ),
      actionsIconTheme: const IconThemeData(
          color: Colors.black
      ),
      // color: Colors.white,
      foregroundColor: Colors.black,
      backgroundColor: Colors.blue.shade50,
    ),

    tabBarTheme: const TabBarTheme(
      labelColor: Colors.black,
    ),



    primaryColor: const Color(0xff6E0097),
    textTheme: const TextTheme(



        titleMedium: TextStyle(
          fontFamily: 'calson',
            color: Colors.black
        )
    ),
    backgroundColor: Colors.white,
    secondaryHeaderColor: Colors.grey,
    disabledColor: const Color(0xffe2e2e2),// use for background in book details
    errorColor: const Color(0xffd2d2d2),// use for process indicator in book details

  );
}