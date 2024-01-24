
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
  Map<String,String> bookMarks = {};

  @HiveField(7)
  List<String> duration = [];

  @HiveField(8)
  String? bookName;

  @HiveField(9)
  String? bookAuthor;

  @HiveField(10)
  String? total;

  @HiveField(11)
  String? listened;

  @HiveField(12)
  int? status;

  @HiveField(13)
  String? startDate;

  @HiveField(14)
  String? finishDate;

  @HiveField(15)
  bool? fav;


  Book({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.audio,
    this.story = ''
 });

  void setTitleAndAuthor(){
    if(title.contains('–')) {
      bookAuthor =
          title.substring(0, title.indexOf('–'));
      bookName = title.substring(
          title.indexOf('–') + 2, title.length - 9);
    }else{
      bookName = title;
      bookAuthor = '  ';
    }
  }

  String getImage(){
    if(imageUrl == null) return ' ';
    return imageUrl!;
  }
  String getBookName(){
    if(bookName != null) return bookName!;
    setTitleAndAuthor();
    return bookName!;
  }
  String getAuthor(){
    if(bookAuthor != null) return bookAuthor!;
    setTitleAndAuthor();
    return bookAuthor!;
  }
  String getStory(){
    if(story == null) return ' ';
    story = story!.replaceAll('<p>', '');
    story = story!.replaceAll('</p>', '');
    story = story!.replaceAll('<b>', '');
    story = story!.replaceAll('</b>', '');
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
    if(duration.isEmpty){
      return "0";
    }
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

  Duration getLeft(){
    Duration left = Duration.zero;

    Duration length = Duration.zero;
    for(String i in duration){
      length += parseDuration(i);
    }
    Duration listen = Duration.zero;
    for(String i in position){
      listen += parseDuration(i);
    }
    return (length-listen);
  }

  double getPercentageListenedDouble(){

    Duration length = Duration.zero;
    for(String i in duration){
      length += parseDuration(i);
    }
    Duration listen = Duration.zero;
    for(String i in position){
      listen += parseDuration(i);
    }

    final double percentage = (listen.inMilliseconds/length.inMilliseconds) * 100 ;

    if(percentage >= 0.0 && percentage <= 100.00){
      return percentage;
    }
    // if(percentage == double.nan){
    //   return 0.0;
    // }else if(percentage == double.infinity){
    //   return 0.0;
    // }

    return 0.0;
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
