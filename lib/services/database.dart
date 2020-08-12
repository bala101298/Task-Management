import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasker/Pages/add_assigntask_page.dart';
import 'package:tasker/Pages/add_project.dart';

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
      int priority,
      DateTime createdDate,
      bool pending}) async {
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
      'Priority': priority,
      'CreatedOn': createdDate,
      'Pending': pending,
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

  sendFriendRequest(String id, requestdata) async {
    return await _firestore
        .collection('User_Management')
        .document(id)
        .collection('Friend Requests')
        .document(uid)
        .setData(requestdata);
  }

  deleteFriendRequest(String id) async {
    return await _firestore
        .collection('User_Management')
        .document(uid)
        .collection('Friend Requests')
        .document(id)
        .delete();
  }

  addFriend1(String id, frienddata) async {
    return await _firestore
        .collection('User_Management')
        .document(uid)
        .collection('Friends')
        .document(id)
        .setData(frienddata);
  }

  addFriend2(String id, mydata) async {
    return await _firestore
        .collection('User_Management')
        .document(id)
        .collection('Friends')
        .document(uid)
        .setData(mydata);
  }

  Future searchUser(String email) async {
    return await _firestore
        .collection('User_Management')
        .where('Email', isEqualTo: email)
        .getDocuments();
  }

  addproject(
      String projectname,
      String projectdes,
      String duedate,
      String startdate,
      String createddate,
      List members,
      String adminName) async {
    return await _firestore
        .collection('Projects')
        .document(projectname)
        .setData({
      'Project Name': projectname,
      'Project Description': projectdes,
      'Start Date': startdate,
      'Date of Completion': duedate,
      'Members': members,
      'Created on': createddate,
      'Admin': adminName,
    });
  }

  updatemembers(List members, String projectname) async {
    return await _firestore
        .collection('Projects')
        .document(projectname)
        .updateData(
      {'Members': members},
    );
  }

  deleteproject(String projectname) async {
    return await _firestore
        .collection('Projects')
        .document(projectname)
        .delete();
  }

  addassignedTask(String projectname, String timestamp, List assigndedto,
      DateTime duedate, String task, String taskdes) async {
    DateTime startDate = DateTime.now();
    final user = await FirebaseAuth.instance.currentUser();
    return await _firestore
        .collection('Projects')
        .document(projectname)
        .collection('Tasks')
        .document(timestamp)
        .setData({
      'Assignor': user.displayName,
      'Assigned To': assignedto,
      'Task': task,
      'Task Description': taskdes,
      'Due Date': duedate,
      'timestamp': timestamp,
      'Start Date': startDate,
    });
  }

  deleteassignedTask(String taskstamp, String projectname) async {
    return await _firestore
        .collection('Projects')
        .document(projectname)
        .collection('Tasks')
        .document(taskstamp)
        .delete();
  }

  addSubTask(String projectname, String taskstamp, String subtask,
      String timestamp) async {
    return await _firestore
        .collection('Projects')
        .document(projectname)
        .collection('Tasks')
        .document(taskstamp)
        .collection('SubTasks')
        .document(timestamp)
        .setData({'SubTask': subtask, 'timestamp': timestamp});
  }

  deleteSubTask(
      String projectname, String taskstamp, String subtaskstamp) async {
    return await _firestore
        .collection('Projects')
        .document(projectname)
        .collection('Tasks')
        .document(taskstamp)
        .collection('SubTasks')
        .document(subtaskstamp)
        .delete();
  }
}
