
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../repository/localdata.dart';

class LocalRepositoryBloc extends Bloc<LocalRepositoryEvent , LocalRepositoryState>{
  late final LocalRepository localRepository;
  LocalRepositoryBloc(this.localRepository) : super(LocalRepositoryInitialState()){

    on<LocalRepositoryAddBookEvent>((event,emit){
      emit(LocalRepositoryAddBookState());
    });

    on<LocalRepositorySortBooksEvent>((event,emit){
      emit(LocalRepositorySortBooksState());
    });

    on<LocalRepositoryBookUpdateEvent>((event,emit){
      emit(LocalRepositoryBookUpdateState());
    });

    on<LocalRepositoryDeleteEvent>((event,emit){
      emit(LocalRepositoryDeleteState());
    });

    on<LocalRepositoryChangeStateEvent>((event,emit){
      emit(LocalRepositoryChangeState());
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
  @override
  List<Object?> get props => [];
}

class LocalRepositorySortBooksEvent extends LocalRepositoryEvent{
  @override
  List<Object?> get props => [];
}

class LocalRepositoryBookUpdateEvent extends LocalRepositoryEvent{
  @override
  List<Object?> get props => [];
}

class LocalRepositoryDeleteEvent extends LocalRepositoryEvent{
  @override
  List<Object?> get props => [];
}

class LocalRepositoryChangeStateEvent extends LocalRepositoryEvent{
  @override
  List<Object?> get props => [];
}


// State

abstract class LocalRepositoryState extends Equatable {}

class LocalRepositoryInitialState extends LocalRepositoryState{
  @override
  List<Object?> get props =>[];
}

class LocalRepositoryAddBookState extends LocalRepositoryState{
  @override
  List<Object?> get props =>[];
}

class LocalRepositoryBookUpdateState extends LocalRepositoryState{
  @override
  List<Object?> get props =>[];
}
class LocalRepositorySortBooksState extends LocalRepositoryState{
  @override
  List<Object?> get props =>[];
}

class LocalRepositoryDeleteState extends LocalRepositoryState{
  @override
  List<Object?> get props =>[];
}

class LocalRepositoryChangeState extends LocalRepositoryState{
  @override
  List<Object?> get props =>[];
}
