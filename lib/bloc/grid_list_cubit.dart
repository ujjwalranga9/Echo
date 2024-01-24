
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class GridListCubit extends Cubit<GridListState>{
  GridListCubit() : super(GridState());

  void toggle(){
    emit(state is GridState ? ListState() : GridState());
  }
}



class GridListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GridState extends GridListState{}
class ListState extends GridListState{}