import 'package:flutter/material.dart';
import 'screens/note_list_screen.dart';
import 'services/note_storage.dart';

void main() {
  runApp(const DogJournalApp());
}

class DogJournalApp extends StatelessWidget {
  const DogJournalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dog Journal',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(primary: Colors.brown),
        useMaterial3: true,
      ),
      home: NoteListScreen(storage: NoteStorage()),
    );
  }
}
