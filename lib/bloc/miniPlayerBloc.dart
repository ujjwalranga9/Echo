

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class MiniPlayerBloc extends Bloc<MiniPlayerEvent,MiniPlayerState>{
  MiniPlayerBloc() : super(MiniPlayerLoadingState()){
    on<MiniPlayerLoadingEvent>((event, emit) {
      emit(MiniPlayerLoadingState());
    });

    on<MiniPlayerLoadedEvent>((event, emit) {
      emit(MiniPlayerLoadingState());

      emit(MiniPlayerLoadedState());
    });

    on<MiniPlayerDismissEvent>((event, emit) {
        emit(MiniPlayerLoadingState());

        emit(MiniPlayerDismissState());
    });
  }

}



// Events
class MiniPlayerEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class MiniPlayerLoadingEvent extends MiniPlayerEvent{}
class MiniPlayerLoadedEvent extends MiniPlayerEvent{}
class MiniPlayerDismissEvent extends MiniPlayerEvent{}

//State
class MiniPlayerState extends Equatable{
  @override
  List<Object?> get props => [];
}

class MiniPlayerLoadingState extends MiniPlayerState{}
class MiniPlayerLoadedState extends MiniPlayerState{}
class MiniPlayerDismissState extends MiniPlayerState{}