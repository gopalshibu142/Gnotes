import 'package:flutter/material.dart';
import './colors.dart';

void main() {
  runApp(const Notes());
}

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  UI ui = UI();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes',
      theme: ThemeData.dark(
      ),
      home: const NotesApp(),
    );
  }
}

class NotesApp extends StatefulWidget {
  const NotesApp({Key? key}) : super(key: key);

  @override
  State<NotesApp> createState() => _NotesAppState();
}

class _NotesAppState extends State<NotesApp> {
  var _notes = <Note>[];
  UI ui = UI();
  void _showAddNoteModal(BuildContext context) {
    showModalBottomSheet(
      backgroundColor:Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        String title = '';
        String content = '';

        return Container(
          decoration: BoxDecoration(
            color: ui.primaryColor,
            borderRadius: BorderRadius.only(topLeft:Radius.circular(20),topRight: Radius.circular(20))
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                onChanged: (value) {
                  setState(() {
                    title = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Content',
                ),
                onChanged: (value) {
                  setState(() {
                    content = value;
                  });
                },
                maxLines: null, // Set maxLines to null for multiline input
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _notes.add(Note(
                        dateTime: DateTime.now(),
                        title: title,
                        content: content,
                      ));
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showAddNoteModal(context);
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Text(
            'Notes',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyText1!.color,
            ),
          ),
          ListView.builder(
            padding: const EdgeInsets.all(16),
            shrinkWrap: true,
            itemCount: _notes.length,
            itemBuilder: (context, index) {
              return Container(
               // 
                decoration:BoxDecoration(
                  color: Theme.of(context).secondaryHeaderColor,
                  border: Border.all(color: ui.extra),
                  borderRadius: BorderRadius.circular(10),

                ) ,
                child: ListTile(
                  
                  title: Text(_notes[index].title
                  ),
                  subtitle: Text(_notes[index].content,
                  ),
                  trailing: Text(_notes[index].dateTime.toString()),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class Note {
  DateTime dateTime;
  String title;
  String content;
  Note({
    required this.dateTime,
    required this.title,
    required this.content,
  });
}
