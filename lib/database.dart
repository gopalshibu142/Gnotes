import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import './main.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

late var collection;

Future initializeHive() async {
  final appDocumentDir = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
}

Future pushData(Note note) async {
  final notesBox = await Hive.openBox<Map>('notes');
  await notesBox.add({
    'title': note.title,
    'content': note.content,
    'date': note.dateTime,
  });

  await notesBox.close();
}

Future<List<Note>> getData() async {
  final notesBox = await Hive.openBox('notes');

  final noteList = notesBox.values.map((noteMap) {
    return Note(
      title: noteMap['title'],
      content: noteMap['content'],
      dateTime: noteMap['date'],
    );
  }).toList();
  for (var i = 0; i < noteList.length; i++) {
    print(noteList[i].title);
  }
  //print(noteList[0].content);
  await notesBox.close();
  return noteList;
}

Future deleteData(int index) async {
  final notesBox = await Hive.openBox('notes');
  await notesBox.deleteAt(index);
  await notesBox.close();
}