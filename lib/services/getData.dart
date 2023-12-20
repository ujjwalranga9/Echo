import 'package:echo/widgets/imageWidget.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

import '../class/book.dart';

class GetData extends StatefulWidget {
  static String image = '';
  String url;
  final Book book;
   GetData({super.key,  required this.url,required this.book});

  @override
  State<GetData> createState() => _GetDataState();
}

class _GetDataState extends State<GetData> {

  late String search;
  List<String> urlImage = [];



  @override
  void initState(){
    addPlusToUrl();
    search = 'https://www.goodreads.com/search?q=${widget.url}';
    getWebsiteData();


    super.initState();
  }

 Future getWebsiteData() async {
   final url = Uri.parse(search);
   final response = await http.get(url);
   dom.Document html = dom.Document.html(response.body);

   final urlImages = html
       .querySelectorAll('td img')
       .map((e) => e.attributes['src']!)
       .toList();

   for( String s in urlImages){
     if(s.endsWith("jpg") || s.endsWith("png")){
       var str = s.split('._');
       var str2 = s.split('_.');
       urlImage.add(str[0]+'.'+ str2[1]);
     }
   }
   print(urlImage);
   setState((){
   });

 }
  @override
  Widget build(BuildContext context) {

     return Scaffold(
       appBar: AppBar(
         title: const Text("Change Image"),
         backgroundColor: Colors.blue.shade50,
         actions: [
           IconButton(onPressed: (){
             widget.url = widget.book.getAuthor();
             search = 'https://www.goodreads.com/search?q=${widget.url}';
             getWebsiteData();


           }, icon: const Icon(Icons.person_search))
         ],
       ),
      body: (urlImage.isEmpty == true) ? const Center(child: CircularProgressIndicator(),) :GridView.builder(
        itemCount: urlImage.length,
        gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 4/6,
        ),
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: (){
                widget.book.imageUrl = urlImage[index];
                Hive.box<Book>("Lib").put(widget.book.getBookName() +widget.book.id, widget.book);
                Navigator.of(context).pop();
              },
              child: Image(image: NetworkImage(urlImage[index]),width: 300,));
        },
      ),
    );
  }

  void addPlusToUrl() {
    widget.url.replaceAll(' ', '+');
  }
}
