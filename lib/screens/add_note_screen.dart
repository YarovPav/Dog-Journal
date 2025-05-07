import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../models/dog_note.dart';
import '../services/note_storage.dart';

class AddNoteScreen extends StatefulWidget {
  const AddNoteScreen({super.key, required this.storage});

  final NoteStorage storage;

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _titleCtrl = TextEditingController();
  final _commentCtrl = TextEditingController();
  Uint8List? _imageBytes;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _commentCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    try {
      final XFile? picked = await picker.pickImage(
        source: ImageSource.gallery,
        requestFullMetadata: false,
        imageQuality: 95,
      );
      if (picked == null) return;
      _imageBytes = await picked.readAsBytes();
      setState(() {});
    } on PlatformException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Не удалось загрузить фото: ${e.code}')),
      );
    }
  }

  Future<void> _save() async {
    if (_titleCtrl.text.trim().isEmpty) return;

    final note = DogNote(
      title: _titleCtrl.text.trim(),
      comment: _commentCtrl.text.trim(),
      imageBase64: _imageBytes != null ? base64Encode(_imageBytes!) : '',
      createdAt: DateTime.now(),
    );
    await widget.storage.addNote(note);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Новая заметка')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Заголовок'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _commentCtrl,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: const InputDecoration(
                labelText: 'Комментарий',
                border: UnderlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            if (_imageBytes != null)
              Image.memory(_imageBytes!, height: 150, fit: BoxFit.cover),
            TextButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.photo_library),
              label: const Text('Выбрать фото'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _save,
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}
