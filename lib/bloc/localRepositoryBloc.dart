
import 'package:bloc/bloc.dart';
import 'package:echo/class/enum.dart';
import 'package:equatable/equatable.dart';

import '../class/book.dart';
import '../repository/localdata.dart';

class LocalRepositoryBloc extends Bloc<LocalRepositoryEvent , LocalRepositoryState>{
  late final LocalRepository localRepository;
  LocalRepositoryBloc(this.localRepository) : super(LocalRepositoryInitialState()){

    on<LocalRepositoryAddBookEvent>((event,emit){
      emit(LocalRepositoryAddBookState(event.book));
    });

    on<LocalRepositorySortBooksEvent>((event,emit){
      emit(LocalRepositorySortBooksState());
    });

    on<LocalRepositoryBookUpdateEvent>((event,emit){
      emit(LocalRepositoryBookUpdateState(newBook: event.newBook,oldBook: event.oldBook));
    });

    on<LocalRepositoryDeleteEvent>((event,emit){
      emit(LocalRepositoryInitialState());
      localRepository.deleteBook(event.book);
      emit(LocalRepositoryDeleteState(event.book));
    });

    on<LocalRepositoryChangeStateEvent>((event,emit){
      emit(LocalRepositoryInitialState());
      localRepository.changeState(book: event.book, state: event.readingState);
      emit(LocalRepositoryChangeState(book: event.book,readingState: event.readingState));
    });


  }




}



// Events

abstract class LocalRepositoryEvent extends Equatable {}

class LocalRepositoryInitialEvent extends LocalRepositoryEvent {
  @override
  List<Object?> get props => [];
}

class LocalRepositoryAddBookEvent extends LocalRepositoryEvent{
  final Book book;
  LocalRepositoryAddBookEvent(this.book);
  @override
  List<Object?> get props => [book];
}

class LocalRepositorySortBooksEvent extends LocalRepositoryEvent{
  @override
  List<Object?> get props => [];
}

class LocalRepositoryBookUpdateEvent extends LocalRepositoryEvent{
  final Book oldBook;
  final Book newBook;
  LocalRepositoryBookUpdateEvent({required this.oldBook,required this.newBook});
  @override
  List<Object?> get props => [oldBook,newBook];
}

class LocalRepositoryDeleteEvent extends LocalRepositoryEvent{
  final Book book;
  LocalRepositoryDeleteEvent(this.book);
  @override
  List<Object?> get props => [book];
}

class LocalRepositoryChangeStateEvent extends LocalRepositoryEvent{
  final Book book;
  final ReadingState readingState;
  LocalRepositoryChangeStateEvent({required this.book,required this.readingState});
  @override
  List<Object?> get props => [book,readingState];
}


// State

abstract class LocalRepositoryState extends Equatable {}

class LocalRepositoryInitialState extends LocalRepositoryState{
  @override
  List<Object?> get props =>[];
}

class LocalRepositoryAddBookState extends LocalRepositoryState{
  final Book book;
  LocalRepositoryAddBookState(this.book);
  @override
  List<Object?> get props =>[book];
}

class LocalRepositoryBookUpdateState extends LocalRepositoryState{

  final Book oldBook;
  final Book newBook;
  LocalRepositoryBookUpdateState({required this.oldBook,required this.newBook});
  @override
  List<Object?> get props =>[oldBook,newBook];
}
class LocalRepositorySortBooksState extends LocalRepositoryState{
  @override
  List<Object?> get props =>[];
}

class LocalRepositoryDeleteState extends LocalRepositoryState{
  final Book book;
  LocalRepositoryDeleteState(this.book);
  @override
  List<Object?> get props =>[book];
}

class LocalRepositoryChangeState extends LocalRepositoryState{
  final Book book;
  final ReadingState readingState;
  LocalRepositoryChangeState({required this.book,required this.readingState});
  @override
  List<Object?> get props =>[book,readingState];
}
