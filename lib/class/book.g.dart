// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BookAdapter extends TypeAdapter<Book> {
  @override
  final int typeId = 0;

  @override
  Book read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Book(
      id: fields[0] as String,
      title: fields[1] as String,
      imageUrl: fields[2] as String?,
      audio: (fields[4] as List).cast<String>(),
    )
      ..story = fields[3] as String?
      ..position = (fields[5] as List).cast<String>()
      ..bookMarks = (fields[6] as Map).map((dynamic k, dynamic v) =>
          MapEntry(k as String, (v as Map).cast<double, double>()))
      ..duration = (fields[7] as List).cast<String>();
  }

  @override
  void write(BinaryWriter writer, Book obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.story)
      ..writeByte(4)
      ..write(obj.audio)
      ..writeByte(5)
      ..write(obj.position)
      ..writeByte(6)
      ..write(obj.bookMarks)
      ..writeByte(7)
      ..write(obj.duration);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
