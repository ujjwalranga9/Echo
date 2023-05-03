import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

import 'package:echo/main.dart';

class DownloadManager{
  static var value = ValueNotifier<double>(0);
}
bool downloaded(String name) {
  final dir = externalDirectory;
  final filePath = '${dir.path}/$name.mp3';
  if( File(filePath).existsSync()){
    return true;
  }
  return false;
}

Future<File> downloadAudioFile(String url,String name) async {

  final dir = externalDirectory;
  final filePath = '${dir.path}/$name.mp3'; // replace "audio.mp3" with the desired filename

  if( downloaded(name)){
    return File(filePath);
  }

  final dio = Dio();

  try {
    await dio.download(url, filePath,
      onReceiveProgress: (rec,total){
        DownloadManager.value = (rec/total) as ValueNotifier<double> ;
      }
    );
    return File(filePath);
  } catch (e) {
    throw Exception('Failed to download audio file: $e');
  }
}
