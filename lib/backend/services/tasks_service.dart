import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskService {
  final _db = FirebaseFirestore.instance;

  Future<String> createTask({
    required String title,
    required String description,
    required String priority,
    required String assigneeName,
    required String assigneeUid,
    DateTime? dueDate,
  }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw Exception("You are not logged in.");
    }

    final doc = await _db.collection('tasks').add({
      "title": title.trim(),
      "description": description.trim(),
      "priority": priority,
      "status": "To Do",
      "assigneeUid":assigneeUid,
      "assigneeName": assigneeName,
      "dueDate": dueDate == null ? null : Timestamp.fromDate(dueDate),
      "createdByUid": uid,
      "createdAt": FieldValue.serverTimestamp(),
    });

    return doc.id;
  }
}