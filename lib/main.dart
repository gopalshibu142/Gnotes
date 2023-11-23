import 'package:flutter/material.dart';
import './colors.dart';
import './database.dart';

void main() async {
  // initDb();

  WidgetsFlutterBinding.ensureInitialized();
  await initializeHive();
  _notes = await getData();
  runApp(const Notes());
}

var _notes = <Note>[];

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
      theme: ThemeData.dark(),
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
  void initVal() async {
    _notes = await getData();
  }

  @override
  void initState() {
    initVal();
    super.initState();
  }

  UI ui = UI();

  void _showAddNoteModal(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController contentController = TextEditingController();
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        String title = '';
        String content = '';

        return Container(
          decoration: BoxDecoration(
              color: ui.primaryColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          padding: const EdgeInsets.all(16),
          child: Column(
          //  crossAxisAlignment: CrossAxisAlignment.,
            children: [
              SizedBox(
                height: 10,),
              const Text(
                'Add Note',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  
                ),
              
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                ),
                maxLines: null, // Set maxLines to null for multiline input
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () async{
                    if (titleController.text.isEmpty ||
                        contentController.text.isEmpty) {
                      //show alert dialog
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Error'),
                            content: const Text(
                                'Please enter both title and content of the note'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                      return;
                    }
                    var note = Note(
                      dateTime: DateTime.now(),
                      title: titleController.text,
                      content:  contentController.text,
                    );
                    setState(() {
                      _notes.add(note);
                    });
                    await pushData(note);
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(100, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    
                  ),
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
      backgroundColor: ui.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showAddNoteModal(context);
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Text(
              'Notes',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyText1!.color,
              ),
            ),
            _notes.isEmpty
                ? SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: const Center(
                      child: Text('No notes yet'),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    shrinkWrap: true,
                    itemCount: _notes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Container(
                          //
                          //padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(

                            color: ui.primaryColor,
                            border: Border.all(color: ui.extra),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.6),
                                blurRadius: 8,
                                spreadRadius: 0.8,
                                offset: const Offset(5, 8),
                              ),
                            ],
                          ),
                          
                          child: ListTile(
                            title: Text(_notes[index].title),
                            subtitle: Text(
                              _notes[index].content,
                              maxLines: null,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onLongPress: () {
                              //show alert dialog
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Delete Note'),
                                    content: const Text(
                                        'Are you sure you want to delete this note?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            _notes.removeAt(index);
                                            
                                          });
                                          deleteData(index);
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            trailing: Text(
                                _notes[index].dateTime.day.toString() +
                                    '/' +
                                    _notes[index].dateTime.month.toString() +
                                    '/' +
                                    _notes[index].dateTime.year.toString() +
                                    '\n\n' +
                                    [
                                      'Monday',
                                      'Tuesday',
                                      'Wednesday',
                                      'Thursday',
                                      'Friday',
                                      'Saturday',
                                      'Sunday'
                                    ][_notes[index].dateTime.weekday - 1]),
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
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
