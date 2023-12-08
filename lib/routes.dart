import 'package:echo/screens/Home/home.dart';
import 'package:echo/screens/library/library.dart';
import 'package:echo/search.dart';
import 'package:echo/settings.dart';
import 'package:echo/widgets/libraryView.dart';
import 'package:flutter/material.dart';
import 'loading.dart';

class AppRouter {

   Route onGenerateRoute(RouteSettings routeSettings){

       switch(routeSettings.name){
         case '/': return MaterialPageRoute(builder: (_) =>  Loading());
         case '/home': return MaterialPageRoute(builder: (_) =>  HomePage());
         case '/lib': return MaterialPageRoute(builder: (_) => Lib());
         case '/toRead': return MaterialPageRoute(builder: (_) => LibraryView(state: 0,));
         case '/inProgress': return MaterialPageRoute(builder: (_) => LibraryView(state: 1,));
         case '/done': return MaterialPageRoute(builder: (_) => LibraryView(state: 2,));


         case '/settings': {
           final fun = routeSettings.arguments as Function;
           return MaterialPageRoute(builder: (_) => Settings(fun: fun,));
         }

         case '/search': {
           final fun = routeSettings.arguments as Function;
           return MaterialPageRoute(builder: (_) => Search(update: fun,));
         }

         default:
            return MaterialPageRoute(builder: (_) =>  HomePage());
       }
   }

   void dispose(){

   }


}