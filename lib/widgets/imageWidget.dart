import 'dart:io';
import 'package:flutter/material.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:path/path.dart' as p;
import '../class/book.dart';
import '../main.dart';

class ImageWidget extends StatelessWidget {
  final Book book;
  final double width;
  final double? height;
  const ImageWidget({Key? key,required this.book,required this.width, this.height}) : super(key: key);

  File file(String filename)  {
    String pathName = p.join(directory.path, filename);
    return File(pathName);
  }

  @override
  Widget build(BuildContext context) {
    return  (height == null) ? Image(
      width: width,
      fit: BoxFit.cover,
      image: NetworkToFileImage(
        url: book.getImage(),
        file: file(book.getImage().substring(book.getImage().lastIndexOf('/')+1,book.getImage().length)),
        //debug: true,
      ),
      errorBuilder: (context, error, stackTrace) {
        return  Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 175,
                height: 260,
                color: const Color(0xff191919),
              ),
              Image.asset('audiobook.png',
                fit: BoxFit.cover,
                width: 175,
              ),
            ]);
      },
    )

        : Image(
       height:  height,
       width: width,
       fit: BoxFit.cover,
      image: NetworkToFileImage(
        url: book.getImage(),
        file: file(book.getImage().substring(book.getImage().lastIndexOf('/')+1,book.getImage().length)),
        //debug: true,
      ),
      errorBuilder: (context, error, stackTrace) {
        return  Stack(
                        alignment: Alignment.center,
                        children: [
                           Container(
                            width: width,
                            height: height,
                            color: const Color(0xff191919),
                          ),
                          Image.asset('audiobook.png',
                          fit: BoxFit.cover,
                            width: width,
                            height: height,
                          ),
                      ]);
      },
    );
  }
}
