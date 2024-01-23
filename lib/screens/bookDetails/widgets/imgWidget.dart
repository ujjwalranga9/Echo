import 'package:flutter/material.dart';

import '../../../class/book.dart';
import '../../../services/getData.dart';
import '../../../widgets/imageWidget.dart';

Widget imageWid(Size size,context,Book book,bool type){
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20.0),
    ),
    elevation: 4,

    child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ImageWidget(book: book, width: size.width/2.2,
          height: (type) ? size.width/2.2 : null,
        )
    ),
  );
}