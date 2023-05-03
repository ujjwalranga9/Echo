import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

import 'package:echo/main.dart';

import '../class/book.dart';

class DownloadManager{
   static var value = ValueNotifier<double>(0);
   static List<int> index = [];


  static Future<File> downloadAudioFile(String url,String name,Function refresh) async {

    final dir = externalDirectory;
    final filePath = '${dir.path}/$name.mp3'; // replace "audio.mp3" with the desired filename

    if( downloaded(name)){
      return File(filePath);
    }

    final dio = Dio();
    value.value = 0;

    try {
      await dio.download(url, filePath,
        onReceiveProgress: (rec,total){
    value.value = (rec/total) ;

          print(value.value*100.floor());

          refresh();

        },

      );
      value.value = 0;
      return File(filePath);
    } catch (e) {
      throw Exception('Failed to download audio file: $e');
    }
  }


}
bool downloaded(String name) {
  final dir = externalDirectory;
  final filePath = '${dir.path}/$name.mp3';
  if( File(filePath).existsSync()){
    return true;
  }
  return false;
}



Widget downloading(Book book,int index,BuildContext context,Function refresh){


  return Container(
    child:
    (DownloadManager.value.value == 0  || !DownloadManager.index.contains(index)) ?
    IconButton(
      onPressed: (){
        print("\nDownload Started");
        DownloadManager.index.add(index);
        DownloadManager.downloadAudioFile(book.audio[index],"${book.title}_$index",refresh).then((value) {
        print("\nDownload Finished");
        DownloadManager.index.remove(index);
        refresh();

      });

    },icon: Icon(downloaded("${book.title}_$index") == true ? Icons.file_download_done :Icons.file_download_outlined,color:downloaded("${book.title}_$index") == true ? Theme.of(context).primaryColor : Colors.white,),
      splashRadius: 20,
    )
        : Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
      alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: DownloadManager.value.value,
                color: Colors.purple,
              ),
              Text("${(DownloadManager.value.value*100).floor()}%",style: const TextStyle(color: Colors.white),),
            ],
          ),
        ),
  );
}



Future<void> setLength(Book book,Function refresh) async {

  AudioPlayer audioPlayer = AudioPlayer();
  for(int i = 0 ; i < book.audio.length ; ++i){
    await audioPlayer.setUrl(book.audio[i]);
    book.duration[i] = audioPlayer.duration.toString();
    refresh();

  }
  audioPlayer.dispose();
}