
import 'package:hive/hive.dart';
import '../class/book.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' as dom;


class GetWebData {

  static Future<List<Book>> getWebsiteDataInFormOfBook(String webUrl,bool search) async {

    if(!search) {
      var box = Hive.box<Book>("Books101");

      if(box.containsKey("$webUrl 0")){
        List<Book> books= [];

        for(int i = 0 ; i < box.length ; i++){
          var bok = box.get("$webUrl $i");
          if(bok == null)continue;
          books.add(bok);
        }
        return books;
      }

    }
    final url = Uri.parse(webUrl);
    final response = await http.get(url);
    dom.Document html = dom.Document.html(response.body);

    List<Book> b= [];

    final data = html.querySelectorAll('body article').map((e) {
      String? id = e.attributes['id'];
      String title = e.querySelector('h2 > a')!.innerHtml.toString();
      String? image;
      if(!search) image = e.querySelector('img')?.attributes['data-lazy-src'].toString();
      if(search)  image = e.querySelector('img')?.attributes['src'].toString();
      List<String> audio = e.querySelectorAll('audio.wp-audio-shortcode > a').map((e) => e.attributes['href']!).toList();
      String? story = e.querySelector('article  div.collapseomatic_content')?.innerHtml.toString();
      Book book = Book(audio: audio, title: title, imageUrl: image,id: id!,story: story);
      b.add(book);

    });

    print(data);

    if(!search) {

      var box = Hive.box<Book>("Books101");
      for(int i = 0 ; i < b.length ; i++){
        box.put("$webUrl $i", b[i]);
      }
    }
    return b;
  }
}
