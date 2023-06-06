
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData darkTheme() {
  return ThemeData(



  appBarTheme:  const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light
    ),
      actionsIconTheme: IconThemeData(
           color: Colors.white
        ),

      foregroundColor: Colors.white,
      backgroundColor: Colors.black,
    ),
primaryColor: const Color(0xff6E0097),

    textTheme: const TextTheme(
        titleMedium: TextStyle(
               color: Colors.white
        )
    ),
  tabBarTheme: const TabBarTheme(

    ),
  backgroundColor: Colors.black,
  disabledColor:  const Color(0xff101010),
  errorColor: const Color(0xff303030),
  buttonTheme: const ButtonThemeData(
      disabledColor: Colors.grey
    ),

  secondaryHeaderColor: Colors.grey,
  iconTheme: const IconThemeData(
      color: Colors.white
    ),
  indicatorColor: Colors.white,
  progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Color(0xff6E0097)
    ),
);

 }