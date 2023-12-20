

import 'package:bloc/bloc.dart';
import '../class/book.dart';

class Books {
  List<Book> books;

  Books({required this.books});
}

class ListOfBooksCubit extends Cubit<List<Book>>{
  ListOfBooksCubit(): super([]);
}