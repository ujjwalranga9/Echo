//  Copyright 2020 Bruno D'Luka

import 'package:books_finder/books_finder.dart';

Future<BookInfo> bookFinder(String name) async {
  final books = await queryBooks(
    name,
    maxResults: 1,
    printType: PrintType.books,
    orderBy: OrderBy.relevance,
    reschemeImageLinks: true,
  );

  // for (final book in books) {
  //   final info = book.info;
  //   print('$info\n');
  // }
  return books[0].info;
}