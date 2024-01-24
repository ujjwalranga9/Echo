import 'package:echo/bloc/book_state_bloc.dart';
import 'package:echo/class/enum.dart';
import 'package:echo/repository/localdata.dart';
import 'package:echo/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../../bloc/bookListBloc.dart';
import '../../bloc/grid_list_cubit.dart';
import '../../bloc/localRepositoryBloc.dart';
import '../../class/book.dart';
import '../../widgets/LibraryGridView.dart';
import '../../widgets/LibraryListView.dart';
import '../../widgets/libraryGrid.dart';
import '../../widgets/libraryList.dart';


class ViewBook extends StatefulWidget {

  final BookState bookState;
  const ViewBook({Key? key,required this.bookState}) : super(key: key);

  @override
  State<ViewBook> createState() => _ViewState();
}

class _ViewState extends State<ViewBook> {

  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      backgroundColor: Colors.white ,

      body: BlocBuilder<GridListCubit,GridListState>(
          builder: (context,state) {
            return SafeArea(

              child: (state is GridState)
                  ?  BlocBuilder<LocalRepositoryBloc,LocalRepositoryState>(
                    builder: (context,state2) {
                      return LibraryGridView(
                          books: (widget.bookState is ToReadState)
                              ? BlocProvider.of<LocalRepositoryBloc>(context).localRepository.getAllToReadBooks()
                              : (widget.bookState is CurrentlyReadingState)
                              ? BlocProvider.of<LocalRepositoryBloc>(context).localRepository.getAllCurrentlyReadingBooks()
                              : BlocProvider.of<LocalRepositoryBloc>(context).localRepository.getAllCompletedBooks(),
                        );
                    }
                  )
                  : LibraryListView(
                books: (widget.bookState is ToReadState)
                    ? BlocProvider.of<LocalRepositoryBloc>(context).localRepository.getAllToReadBooks()
                    : (widget.bookState is CurrentlyReadingState)
                    ? BlocProvider.of<LocalRepositoryBloc>(context).localRepository.getAllCurrentlyReadingBooks()
                    : BlocProvider.of<LocalRepositoryBloc>(context).localRepository.getAllCompletedBooks(),
              ),

            );
          }
      ),
    );
  }
}
