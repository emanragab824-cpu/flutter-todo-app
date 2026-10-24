
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/todo_model.dart';

class TodoService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> _todosRef() {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('Please sign in first.');
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('todos');
  }

  Future<void> addTodo(
      String title,
      String description,
      ) async {
    await _todosRef().add({
      'title': title.trim(),
      'description': description.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<TodoModel>> getTodos() async {
    final snapshot = await _todosRef()
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => TodoModel.fromFirestore(doc))
        .toList();
  }
}
