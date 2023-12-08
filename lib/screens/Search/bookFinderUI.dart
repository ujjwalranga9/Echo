import 'package:books_finder/books_finder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BooksFinder extends StatefulWidget {
  BooksFinder({required this.info,super.key});
  BookInfo info;

  @override
  State<BooksFinder> createState() => _BooksFinderState();
}

class _BooksFinderState extends State<BooksFinder> {
  @override
  Widget build(BuildContext context) {
    // print(widget.info.imageLinks['thumbnail'].toString());
    return  Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Text(
                widget.info.contentVersion
              ),
              Text(
                  widget.info.description
              ),
              Text(
                  widget.info.language
              ),
              Text(
                  widget.info.pageCount.toString()
              ),
              Text(
                  widget.info.publisher
              ),
              Text(
                  widget.info.rawPublishedDate
              ),
              Text(
                  widget.info.title
              ),
              Text(
                  widget.info.subtitle
              ),
              Text(
                  widget.info.authors.toString()
              ),
              Image.network(widget.info.imageLinks['thumbnail'].toString())
            ],
          ),
        ),
      ),
    );
  }
}
