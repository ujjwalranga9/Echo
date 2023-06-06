
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Echo"),
        centerTitle: true,
        titleSpacing: 2.0,
      ),

      backgroundColor: Theme.of(context).textTheme.titleMedium?.color,



    );
  }
}
