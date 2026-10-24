
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  final String id;
  final String title;
  final String description;
  final Timestamp? createdAt;

  TodoModel({
    required this.id,
    required this.title,
    required this.description,
    this.createdAt,
  });

  factory TodoModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc,
      ) {
    final data = doc.data()!;

    return TodoModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      createdAt: data['createdAt'] as Timestamp?,
    );
  }
}
