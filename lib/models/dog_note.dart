import 'dart:convert';
import 'dart:typed_data';

class DogNote {
  DogNote({
    required this.title,
    required this.comment,
    required this.imageBase64,
    required this.createdAt,
  });

  final String title;
  final String comment;
  final String imageBase64;
  final DateTime createdAt;

  Uint8List? get imageBytes =>
      imageBase64.isEmpty ? null : base64Decode(imageBase64);

  Map<String, dynamic> toJson() => {
        'title': title,
        'comment': comment,
        'image': imageBase64,
        'created_at': createdAt.toIso8601String(),
      };

  factory DogNote.fromJson(Map<String, dynamic> json) => DogNote(
        title: json['title'] as String,
        comment: json['comment'] as String,
        imageBase64: json['image'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
      );
}
