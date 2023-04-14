import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;

class GetData extends StatefulWidget {
  static String image = '';
  final String url;
  GetData({required this.url});

  @override
  State<GetData> createState() => _GetDataState();
}

class _GetDataState extends State<GetData> {

  late String search;
  List<String> urlImage = [];



  @override
  void initState(){
    addPlusToUrl();
    search = 'https://www.audible.in/search?keywords=${widget.url}';
    getWebsiteData();


    super.initState();
  }

 Future getWebsiteData() async {
   final url = Uri.parse(search);
   final response = await http.get(url);
   dom.Document html = dom.Document.html(response.body);

   final urlImages = html
       .querySelectorAll('span picture img')
       .map((e) => e.attributes['src']!)
       .toList();

   setState((){
     urlImage = urlImages;
   });

 }
  @override
  Widget build(BuildContext context) {
    GetData.image = urlImage[0];
    return (urlImage.isNotEmpty) ?Image.network(urlImage[0]) : Container();
  }

  void addPlusToUrl() {
    widget.url.replaceAll(' ', '+');
  }


  // Future getWebsiteData() async {
  //   final url = Uri.parse(widget.url);
  //   final response = await http.get(url);
  //   dom.Document html = dom.Document.html(response.body);
  //
  //   final bookId = html
  //       .querySelectorAll('body article')
  //       .map((e) => e.attributes['id']!)
  //       .toList();
  //
  //   final titles = html
  //       .querySelectorAll('h2 a')
  //       .map((e) => e.innerHtml.trim())
  //       .toList();
  //
  //   final urlImages = html
  //       .querySelectorAll('article img')
  //       .map((e) => e.attributes['data-lazy-src']!)
  //       .toList();
  //
  //   final  audio = html
  //       .querySelectorAll('article').map((e) =>
  //       e.querySelectorAll('audio.wp-audio-shortcode > a').map((e) => e.attributes['href']!).toList());
  //
  //   // final audios = html
  //   //     .querySelectorAll('audio.wp-audio-shortcode > a')
  //   //     .map((e) =>e.attributes['href']!)
  //   //     .toList();
  //
  //   final stories = html
  //       .querySelectorAll('article  div.collapseomatic_content')
  //       .map((e) => e.innerHtml.trim())
  //       .toList();
  //
  //   setState((){
  //     title = titles;
  //     urlImage = urlImages;
  //     story = stories;
  //     id = bookId;
  //     // urlAudio  = audios;
  //     for (var element in audio) {
  //       audioFiles.add(element);
  //     }
  //     //print(id);
  //   });
  //
  // }


}
