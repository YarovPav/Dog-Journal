import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/dog_note.dart';
import '../services/note_storage.dart';
import 'add_note_screen.dart';

class NoteListScreen extends StatefulWidget {
  const NoteListScreen({super.key, required this.storage});

  final NoteStorage storage;

  @override
  State<NoteListScreen> createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  late Future<List<DogNote>> _notesFuture;

  @override
  void initState() {
    super.initState();
    _notesFuture = widget.storage.getNotes();
  }

  Future<void> _refresh() async {
    final notes = await widget.storage.getNotes();
    setState(() {
      _notesFuture = Future.value(notes);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dog Journal')),
      body: FutureBuilder<List<DogNote>>(
        future: _notesFuture,
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final notes = snap.data!;
          if (notes.isEmpty) {
            return const Center(child: Text('Нет заметок'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: notes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) => _NoteTile(note: notes[i]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddNoteScreen(storage: widget.storage),
            ),
          );
          _refresh();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _NoteTile extends StatelessWidget {
  const _NoteTile({required this.note});
  final DogNote note;

  @override
  Widget build(BuildContext context) {
    final Uint8List? bytes = note.imageBytes;
    return Card(
      child: ListTile(
        leading: bytes != null
            ? Image.memory(bytes, width: 56, height: 56, fit: BoxFit.cover)
            : const SizedBox(width: 56, height: 56),
        title: Text(note.title),
        subtitle: Text(
          note.comment,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
