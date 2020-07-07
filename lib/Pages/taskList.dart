import 'package:calendar_strip/calendar_strip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasker/Utils/constants.dart';
import 'package:tasker/Widgets/taskcard.dart';
import 'package:tasker/services/auth.dart';

DateTime selectedDate = DateTime.now();
final _firestore = Firestore.instance;
final _auth = FirebaseAuth.instance;

Authentication authentication = Authentication();

DocumentSnapshot documentSnapshot;

String formatedDate = new DateFormat.yMMMEd().format(selectedDate);
String defaultDate = new DateFormat.yMMMEd().format(DateTime.now());

class TaskListPage extends StatefulWidget {
  const TaskListPage({Key key}) : super(key: key);

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/AddTask");
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
                height: 150,
                child: CalendarStrip(
                  onDateSelected: (date) {
                    setState(() {
                      selectedDate = date;
                      formatedDate = DateFormat.yMMMEd().format(selectedDate);
                    });
                    print(formatedDate);
                  },
                  startDate: DateTime(2019),
                  endDate: DateTime(2025),
                  selectedDate: DateTime.now(),
                  addSwipeGesture: true,
                )),
            Expanded(
              child: taskList(),
            )
          ],
        ),
      ),
    );
  }
}

taskList() {
  return StreamBuilder<QuerySnapshot>(
      stream: taskstream(),
      builder: (context, snapshots) {
        if (!snapshots.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding:
              const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 100),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "You have ${snapshots.data.documents.length} tasks",
                style: kBody_2,
              ),
              SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                    reverse: false,
                    shrinkWrap: true,
                    itemCount: snapshots.data.documents.length,
                    itemBuilder: (context, index) {
                      documentSnapshot = snapshots.data.documents[index];
                      return TaskCard(
                        task: documentSnapshot['task'],
                        timestamp: documentSnapshot['timestamp'],
                        taskCompleted: documentSnapshot['CompletedStatus'],
                        dueDate: documentSnapshot['DueDate'],
                        priority: documentSnapshot['Priority'],
                      );
                    }),
              ),
            ],
          ),
        );
      });
}

Stream<QuerySnapshot> taskstream() async* {
  final user = await _auth.currentUser();

  FirebaseUser currentUser = user;
  print(currentUser.uid);
  yield* _firestore
      .collection('Task Management')
      .document(currentUser.uid)
      .collection('Tasks')
      .orderBy('Priority', descending: true)
      .where("DueDate",
          isEqualTo: formatedDate != null ? formatedDate : defaultDate)
      .snapshots();
}
