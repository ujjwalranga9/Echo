
import 'dart:ui';

import 'package:echo/bloc/localRepositoryBloc.dart';
import 'package:echo/class/enum.dart';
import 'package:echo/repository/localdata.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../bloc/book_state_bloc.dart';
import '../class/book.dart';
import '../screens/bookDetails/widgets/imgWidget.dart';

Future<bool?> deleteDialog({required Book book, required BuildContext context}){
  return showDialog<bool>(context: context,builder: (ctx,){

    return AlertDialog(

      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
      ),backgroundColor: Colors.teal.shade50,

      title: const Center(child: Text("Are you Sure?")),
      content: SizedBox(

        height: MediaQuery.of(context).size.height*0.2,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  imageWid(const Size(250, 100), context, book,true),
                  BlocBuilder<BookStateCubit,BookState>(
                      builder: (context,state) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ChoiceChip(
                              label: const Text("To Do"),

                              selected: (BlocProvider.of<LocalRepositoryBloc>(context).localRepository.getState(book: book) == ReadingState.toRead) ? true : false ,
          
                              onSelected: (val){
                                BlocProvider.of<LocalRepositoryBloc>(context).localRepository.changeState(book: book,state: ReadingState.toRead);
                                BlocProvider.of<BookStateCubit>(context).toRead();
                              }, ),
                            ChoiceChip(label: const Text("Listening"),
                              selected: (BlocProvider.of<LocalRepositoryBloc>(context).localRepository.getState(book: book) == ReadingState.inProgress) ? true : false,
                              onSelected: (val){
                                BlocProvider.of<LocalRepositoryBloc>(context).localRepository.changeState(book: book,state: ReadingState.inProgress);
                                BlocProvider.of<BookStateCubit>(context).reading();
                              }, ),
                            ChoiceChip(label: const Text("Done"),
                              selected: (BlocProvider.of<LocalRepositoryBloc>(context).localRepository.getState(book: book) == ReadingState.done) ? true : false ,
                              onSelected: (val){
                                BlocProvider.of<LocalRepositoryBloc>(context).localRepository.changeState(book: book,state: ReadingState.done);
                                BlocProvider.of<BookStateCubit>(context).done();
                              },),
                          ],
                        );
                      }
                  )
                ],
              ),
              Center(
                child: Text(book.getBookName(), maxLines: 1,overflow: TextOverflow.ellipsis,style:
                const TextStyle(fontSize: 16,), textAlign: TextAlign.center),
              ),
          
            ],
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,

      actions: [

        IconButton(
            onPressed: ()  {

              BlocProvider.of<LocalRepositoryBloc>(context).localRepository.deleteBook(book);
              BlocProvider.of<BookStateCubit>(context).delete();

              Navigator.of(context).pop(true);
              },
            icon: const Icon(Icons.delete)),

        IconButton(
            onPressed: (){
              Navigator.of(context).pop(false);
            },
            icon: const Icon(Icons.close)),

        IconButton(
            onPressed: (){
              Navigator.of(context).pop(false);
            },
            icon: const Icon(Icons.done)),
      ],
    );
  });
}