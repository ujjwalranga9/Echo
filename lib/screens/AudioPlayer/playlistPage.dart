
import 'package:flutter/material.dart';

import '../../class/book.dart';
import '../../main.dart';

class PlaylistPage extends StatefulWidget {

  final Book book;
  const PlaylistPage({super.key,required this.book});
  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {

  Widget progressIndicator(int index){
    return  ClipRRect(
      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10),bottomRight:Radius.circular(10) ),
      child: LinearProgressIndicator(
        color: Colors.indigo,
        backgroundColor: Colors.grey.shade50,
        value:  widget.book.getListenedIndexLength(index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade50,
        title: const Text("Playlist"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15,top: 15),
            child: Text("Left: ${widget.book.getLeft().inHours}h ${widget.book.getLeft().inMinutes-60*widget.book.getLeft().inHours}m"),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue.shade50,Colors.green.shade50]
            )
          ),
          child: ListView.builder(
            itemCount: widget.book.audio.length,
              itemBuilder: (ctx,index){
            return Padding(
              padding: const EdgeInsets.only(left: 15,right: 15,top: 15),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [

                  Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [ Colors.blue.shade50,Colors.green.shade50]
                        ),
                        borderRadius: BorderRadius.circular(20),

                      ),
                      child:ListTile(
                        onTap: (){
                          pageManager.pause();
                          print(index.toString());
                          pageManager.audioFileNum = index;
                          pageManager.setBook(widget.book);
                          Navigator.of(context).pop();
                        },
                        trailing: IconButton(icon: Icon(Icons.download_rounded),onPressed: (){},),
                        title: Text('${index+1}. ${widget.book.getBookName()}'),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text("${widget.book.parseDuration(widget.book.duration[index]).inHours}h ${
                              widget.book.parseDuration(widget.book.duration[index]).inMinutes - widget.book.parseDuration(widget.book.duration[index]).inHours*60}m ${widget.book.parseDuration(widget.book.duration[index]).inSeconds - widget.book.parseDuration(widget.book.duration[index]).inMinutes*60}s"),
                        ),
                      ),
                  ),
                  progressIndicator(index),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
