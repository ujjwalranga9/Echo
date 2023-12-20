

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';



class BookStateCubit extends Cubit<BookState>{
  BookStateCubit() : super(ToReadState());

  void done() => emit(CompleteReadingState());
  void toRead() => emit(ToReadState());
  void reading() => emit(CurrentlyReadingState());
}


abstract class BookState extends Equatable{
  @override
  List<Object?> get props => [];
}

class ToReadState extends BookState{}
class CurrentlyReadingState extends BookState{}
class CompleteReadingState extends BookState{}



