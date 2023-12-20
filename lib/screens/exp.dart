//
// import 'package:echo/widgets/imageWidget.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../bloc/bookListBloc.dart';
// import '../class/book.dart';
//
// class EXP extends StatefulWidget {
//   const EXP({super.key});
//
//   @override
//   State<EXP> createState() => _EXPState();
// }
//
// class _EXPState extends State<EXP> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: BlocBuilder<ListOfBooksCubit,ListOfBooksState>(
//           builder: (context, state) {
//             return Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: state.books.map((e) {
//                 return ImageWidget(book: e, width: 100);
//               }).toList() ,
//             );
//           }
//         ),
//       ) ,
//     );
//   }
// }
