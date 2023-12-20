
import 'package:echo/main.dart';
import 'package:echo/screens/AudioPlayer/audioPlayerClass.dart';
import 'package:echo/screens/bookDetails/widgets/imgWidget.dart';
import 'package:echo/screens/bookDetails/widgets/textUpdate.dart';
import 'package:echo/services/getData.dart';
import 'package:echo/widgets/imageWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:page_transition/page_transition.dart';

import 'package:progress_indicator/progress_indicator.dart';

import '../../class/book.dart';
import '../../services/download.dart';

class BookDetails extends StatefulWidget {
  final Book book;

  const BookDetails({super.key,required this.book});

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {


  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(

        child: CustomScrollView(
          slivers: [

            SliverPersistentHeader(
                delegate: CustomSliverDelegate(
                    expandedHeight: size.height*0.6,
                    size: size,book: widget.book,
                    widget: GestureDetector(
                        onLongPress: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx){
                                return GetData(book: widget.book,url: widget.book.getBookName(),);
                              }));

                        },
                        child: Hero(tag: "image",
                        child: imageWid(size,context,widget.book))),
                  update: (){
                      setState(() {

                      });
                  }
                )
            ),

            SliverToBoxAdapter(
              child: SingleChildScrollView(
                child: Column(
                  children: getL(context, size, widget.book),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


List<Widget> getL(BuildContext context,Size size,Book book){


  return [

    const SizedBox(height: 20,),
    Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text("Language",style: TextStyle(fontSize: 14,color: Colors.grey[600],fontWeight: FontWeight.w500),),
              SizedBox(height: 5,),
              const Text('English',style: TextStyle(fontSize: 18),),
            ],
          ),
          Column(
            children: [
              Text("Parts",style: TextStyle(fontSize: 14,color: Colors.grey[600],fontWeight: FontWeight.w500),),
              SizedBox(height: 5,),
              Text(book.audio.length.toString(),style: const TextStyle(fontSize: 18),),
            ],
          ),
          Column(
            children: [
              Text("Audio",style: TextStyle(fontSize: 14,color: Colors.grey[600],fontWeight: FontWeight.w500),),
              SizedBox(height: 5,),
              Text('${book.bookLength().substring(0,book.bookLength().length-13)}h ${book.bookLength().substring(book.bookLength().length-12,book.bookLength().length-10)}m ',style: const TextStyle(fontSize: 18),),
            ],
          ),
        ],
      ),
    ),

    const SizedBox(height: 10,),

    Padding(
      padding: const EdgeInsets.only(left: 20.0,right: 20.0,bottom: 0,top: 0),
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Story:",style: TextStyle(fontSize: 14,color: Colors.grey[600],fontWeight: FontWeight.w500),),
          Text(book.getStory(),
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16,)),
          // Html(data: book.getStory(),)
        ],
      ),
    ),



  ];
}

Widget bar(Book book){
  return Padding(
    padding:const EdgeInsets.fromLTRB(120, 10, 120, 0),
    child: Row(
      children: [
        Expanded(
          child: BarProgress(
            percentage: book.getPercentageListenedDouble(),
            backColor: Colors.white,
            color: Colors.blue,
            gradient: LinearGradient(colors: [Colors.blue, Colors.indigoAccent]),
            showPercentage: false,
            textStyle:const TextStyle(color: Colors.black,fontSize: 15),
            stroke: 10,
            round: true,
          ),
        ),
        SizedBox(width: 15,),
        Text(book.getPercentageListened())
      ],
    ),
  );
}

Widget getButton(Size size,BuildContext context,Book book){
  return
    Padding(
      padding:  EdgeInsets.fromLTRB(size.width*0.2,10,size.width*0.2,0),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        splashColor: Colors.greenAccent,
        minWidth: size.width*0.6,
        height: 60,

        color: Colors.indigoAccent,
        onPressed: (){

          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (ctx){
          //       return AudioPlayerClass(book: book,);
          //     }));

          // if(pageManager.book.bookName == book.bookName){
          //
          // }else {
            Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.fade,
                    child: AudioPlayerClass(book: book,),
                    duration: const Duration(milliseconds: 350)
                )
            );
          // }
        },

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:  [
            Text(
              (book.getPercentageListened() != '0%' && book.getPercentageListened() != '100%') ? "Continue Listening" : (book.getPercentageListened() == '0%') ?  "Start Listening" : "Audiobook Completed",
              style: const TextStyle(fontSize: 20,color: Colors.white),),
            const SizedBox(width: 10,),
            if(book.getPercentageListened() != '100%') const Icon(Icons.headphones_rounded, color: Colors.white,)
          ],
        ),
      ),
    );
}

class CustomSliverDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final bool hideTitleWhenExpanded;
  final Size size;
  final Book book;
  final Widget widget;
  final Function update;

  CustomSliverDelegate({
    required this.update,
    required this.widget,
    required this.book,
    required this.size,
    required this.expandedHeight,
    this.hideTitleWhenExpanded = true,
  });

  @override
  Widget build( BuildContext context, double shrinkOffset, bool overlapsContent,) {

    final appBarSize = expandedHeight - shrinkOffset;
    final cardTopPosition = expandedHeight/1.075  - shrinkOffset;
    final proportion = 2 - (expandedHeight / appBarSize);
    final percent = proportion < 0 || proportion > 1 ? 0.0 : proportion;
    bool isFav = false;

    if(book.fav == null){
      book.fav = false;
      Hive.box<Book>("Lib").put(book.getBookName() + book.id,book);
    }else{
      isFav = book.fav!;
    }

    return SizedBox(
      height: expandedHeight + 25,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(size.width*0.15),
                  bottomRight: Radius.circular(size.width*0.15)
              )
            ),
            height: appBarSize < kToolbarHeight ? kToolbarHeight : appBarSize,

            child: CustomScrollView(
                physics: const NeverScrollableScrollPhysics(),
              slivers: [

                SliverAppBar(
                  expandedHeight: expandedHeight,
                  backgroundColor: Colors.blue.shade50,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(size.width*0.15),
                          bottomRight: Radius.circular(size.width*0.15)
                    )
                  ),


                  flexibleSpace: FlexibleSpaceBar(

                    background: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(size.width*0.1),
                              bottomRight: Radius.circular(size.width*0.1)
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.blue.shade50,Colors.green.shade50]
                          )
                        ),
                        child: Column(
                           mainAxisAlignment: MainAxisAlignment.end,
                         children: [
                        widget,
                        const SizedBox(height: 16,),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10,0,10,0),
                          child: Text(
                              book.getBookName(),
                              style:  TextStyle(
                                 fontFamily: 'caslon',

                                  fontSize: 25,fontWeight: FontWeight.bold,

                                   shadows: [Shadow(color: Colors.grey.shade50,offset: Offset(0, 0),blurRadius: 3)]
                              ),
                              maxLines: 2,
                              textAlign: TextAlign.center
                          ),
                        ),

                        const SizedBox(height: 1.618,),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10,0,10,0),
                          child: Text(
                              'by ${book.getAuthor()}',

                              style: TextStyle(
                                  fontFamily: 'caslon',
                                  fontSize: 15,
                                  color: Colors.grey[800]
                              ),
                              maxLines: 2,
                              textAlign: TextAlign.center
                          ),
                        ),


                        const SizedBox(height: 1.618,),

                        bar(book),
                        const SizedBox(height: 45,),
                      ],
                    )) ,

                  ),
                  floating: false,
                  collapsedHeight: 100,

                  leading: Padding(
                    padding: const EdgeInsets.only(left: 25,top: 25,),
                    child: IconButton(icon: const Icon(Icons.arrow_back_rounded),onPressed: (){
                      Navigator.of(context).pop();
                    },),
                  ),

                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 25,top: 25),
                      child: IconButton(onPressed: (){
                        isFav = !isFav;
                        book.fav = isFav;
                        Hive.box<Book>("Lib").put(book.getBookName() + book.id,book);
                        update();

                      }, icon: (isFav == false) ? const Icon(Icons.favorite_border_rounded ) : const Icon(Icons.favorite , color: Colors.indigo,)),
                    ),

                  ],
                ),
          ]
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            top: cardTopPosition > 0 ? cardTopPosition : 0,
            bottom: 0.0,
            child: Opacity(
              opacity: percent,
              child: getButton(size,context,book)
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight +25;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}