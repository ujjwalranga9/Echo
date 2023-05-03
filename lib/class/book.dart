
import 'package:hive_flutter/hive_flutter.dart';

part 'book.g.dart';

@HiveType(typeId: 0)
class Book{
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? imageUrl;

  @HiveField(3)
  String? story;

  @HiveField(4)
  List<String> audio;

  @HiveField(5)
  List<String> position = [];

  @HiveField(6)
  Map<String,Map<double,double>> bookMarks = {};

  @HiveField(7)
  List<String> duration = [];

  String _bookName = '';
  String _bookAuthor = '';


  Book({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.audio,
    this.story = ''
 });

  void setTitleAndAuthor(){
    if(title.contains('–')) {
      _bookAuthor =
          title.substring(0, title.indexOf('–'));
      _bookName = title.substring(
          title.indexOf('–') + 2, title.length - 9);
    }else{
      _bookName = title;
      _bookAuthor = '  ';
    }
  }

  String getImage(){
    if(imageUrl == null) return ' ';
    return imageUrl!;
  }
  String getBookName(){
    if(_bookName != '') return _bookName;
    setTitleAndAuthor();
    return _bookName;
  }
  String getAuthor(){
    if(_bookAuthor != '') return _bookAuthor;
    setTitleAndAuthor();
    return _bookAuthor;
  }
  String getStory(){
    if(story == null) return ' ';
    return story!;
  }


  Duration parseDuration(String s) {
    int hours = 0;
    int minutes = 0;
    int micros;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(hours: hours, minutes: minutes, microseconds: micros);
  }

  String bookLength(){
    Duration length = Duration.zero;
    for(String i in duration){
      length += parseDuration(i);
    }
    return length.toString();
  }

  void newBook(){
    for(int i = 0 ; i < position.length ; i++){
      position[i] = Duration.zero.toString();
    }
  }

  void done(){
    if(duration[0] == '0'){
      return;
    }
    for(int i = 0 ; i < duration.length ; i++){
      position[i] = duration[i];
    }
  }

  void reading(){
    if(duration[0] == '0'){
      return;
    }

    for(int i = 0 ; i < position.length ; i++){
      position[i] = '0';
    }
    position[0] = const Duration(seconds: 1).toString();
  }


  String getPercentageListened(){
    Duration length = Duration.zero;
    for(String i in duration){
      length += parseDuration(i);
    }
    Duration listen = Duration.zero;
    for(String i in position){
      listen += parseDuration(i);
    }

    final double percentage = (listen.inMilliseconds/length.inMilliseconds) *100 ;

    return "${percentage.ceil()}%";


  }
  double getListenedIndexLength(int index){
    double x = 0.0;
    int dur = parseDuration(duration[index]).inSeconds;
    int pos = parseDuration(position[index]).inSeconds;
    if(dur == 0){
      return 0;
    }
    return pos/dur;
  }

}
