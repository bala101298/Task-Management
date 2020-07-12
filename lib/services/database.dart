import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = Firestore.instance;

class Database {
  final String uid;
  Database({this.uid});

  Future<void> updateUserData(
      {String displayName, String email, String photoUrl, String token}) async {
    return _firestore.collection('User_Management').document(uid).setData({
      'DisplayName': displayName,
      'Email': email,
      'PhotoUrl': photoUrl,
      'UserId': uid,
      'Device_Token': token,
    });
  }

  Future<void> addTask(
      {String input,
      bool taskCompleted,
      String timestamp,
      String selectedDate,
      int priority}) async {
    return await _firestore
        .collection('Task_Management')
        .document(uid)
        .collection('Tasks')
        .document(timestamp)
        .setData({
      'task': input,
      'CompletedStatus': taskCompleted,
      'timestamp': timestamp,
      'DueDate': selectedDate,
      'Priority': priority
    }, merge: true);
  }

  Future<void> deleteTask(String item) async {
    return await _firestore
        .collection('Task_Management')
        .document(uid)
        .collection('Tasks')
        .document(item)
        .delete();
  }
}
