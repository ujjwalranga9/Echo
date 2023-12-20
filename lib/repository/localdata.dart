
import 'package:echo/class/enum.dart';
import 'package:hive/hive.dart';

import '../class/book.dart';

class LocalRepository {
  final Box<Book> _box =  Hive.box<Book>('Lib');

  List<Book> getAllBooks (){
    List<Book> books = [];
    for(int i = 0 ; i < _box.length ; i++) {
        books.add(_box.getAt(i)!);
    }
    return books;
  }

  List<Book> sortedBooksByLen(){
    List<Book> values = _box.values.toList();
    List<Book> books = [];
    values.sort((a,b)=> a.parseDuration(a.bookLength()).compareTo(b.parseDuration(b.bookLength())));

    for(int i = 0 ; i < values.length ; i++){
      books.add(values[i]);
    }
    return books;
  }

  void addBook(Book book){
    // Hive.box<Book>("Lib").put(book.getBookName() +book.id, book);
    _box.put(book.getBookName() +book.id, book);
  }
  void updateBook({required Book oldBook,required Book newBook}){

    for(int i = 0 ; i < _box.length ; i++) {
     if(_box.getAt(i) == oldBook){
       _box.putAt(i, newBook);
     }
    }
  }

  void deleteBook(Book book){
    // Hive.box<Book>("Lib").delete(book.getBookName() +book.id);
   _box.delete(book.getBookName() +book.id);
  }


  List<Book> getAllToReadBooks (){
    List<Book> books = [];
    for(int i = 0 ; i < _box.length ; i++) {
      if(_box.getAt(i)!.status == 0) {
        books.add(_box.getAt(i)!);
      }
    }
    return books;
  }
  List<Book> getAllCurrentlyReadingBooks (){
    List<Book> books = [];
    for(int i = 0 ; i < _box.length ; i++) {
      if(_box.getAt(i)!.status == 1) {
        books.add(_box.getAt(i)!);
      }
    }
    return books;
  }

  List<Book> getAllCompletedBooks (){
    List<Book> books = [];
    for(int i = 0 ; i < _box.length ; i++) {
      if(_box.getAt(i)!.status == 2) {
        books.add(_box.getAt(i)!);
      }
    }
    return books;
  }

  void changeState({required Book book, required ReadingState state}){
    if(state == ReadingState.toRead){
      book.status = 0;
    }else if (state == ReadingState.inProgress){
      book.status = 1;
    }else{
      book.status = 2;
    }
    _box.put(book.getBookName() +book.id, book);
  }


}