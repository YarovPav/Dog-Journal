import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dog_note.dart';

class NoteStorage {
  static const _key = 'dog_notes';

  Future<List<DogNote>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    final List data = jsonDecode(raw) as List;
    return data.map((e) => DogNote.fromJson(e)).toList();
  }

  Future<void> addNote(DogNote note) async {
    final prefs = await SharedPreferences.getInstance();
    final notes = await getNotes();
    notes.add(note);
    final raw = jsonEncode(notes.map((e) => e.toJson()).toList());
    await prefs.setString(_key, raw);
  }
}
