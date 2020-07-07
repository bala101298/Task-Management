import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tasker/Utils/Constants.dart';
import 'package:tasker/Widgets/card.dart';
import 'package:tasker/Widgets/taskTile.dart';
import 'package:tasker/Widgets/taskcard.dart';
import 'package:tasker/services/auth.dart';

String formatedDate = new DateFormat.yMMMEd().format(DateTime.now());
DocumentSnapshot documentSnapshot;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Authentication().signOut();
                },
                child: Text('Logout'),
              )
            ],
          ),
          body: StreamBuilder(
              stream: userstream(),
              builder: (context, snapshots) {
                if (!snapshots.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: screenHeight * 0.05),
                              Text(
                                "Hello",
                                style: kHeading1,
                              ),
                              Text(
                                snapshots.data.documents[0].data['DisplayName'],
                                style: kHeading2,
                              ),
                            ],
                          ),
                          CircleAvatar(
                            minRadius: 30,
                            maxRadius: 40,
                            backgroundImage: NetworkImage(
                                snapshots.data.documents[0].data['PhotoUrl']),
                          )
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      ContainerCard(
                        onTap: () {
                          Navigator.pushNamed(context, "/TaskList");
                        },
                        child: Text("Personal"),
                        color: Colors.red[200],
                        height: 150,
                      ),
                      SizedBox(height: screenHeight * 0.05),
                      Text(
                        "Today's Tasks",
                        style: kHeading2,
                      ),
                      SizedBox(height: screenHeight * 0.02),
                      Expanded(
                        child: StreamBuilder(
                            stream: todaystream(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              return ListView.builder(
                                  itemCount: snapshot.data.documents.length,
                                  itemBuilder: (context, index) {
                                    documentSnapshot =
                                        snapshot.data.documents[index];
                                    return TaskCard(
                                      task: documentSnapshot['task'],
                                      timestamp: documentSnapshot['timestamp'],
                                      taskCompleted:
                                          documentSnapshot['CompletedStatus'],
                                      dueDate: documentSnapshot['DueDate'],
                                      priority: documentSnapshot['Priority'],
                                    );
                                  });
                            }),
                      ),
                    ],
                  ),
                );
              })),
    );
  }

  Stream<QuerySnapshot> todaystream() async* {
    final user = await FirebaseAuth.instance.currentUser();

    FirebaseUser currentUser = user;
    print(currentUser.uid);
    yield* Firestore.instance
        .collection('Task Management')
        .document(currentUser.uid)
        .collection('Tasks')
        .orderBy('Priority', descending: true)
        .where("DueDate", isEqualTo: formatedDate)
        .snapshots();
  }

  Stream<QuerySnapshot> userstream() async* {
    final user = await FirebaseAuth.instance.currentUser();

    FirebaseUser currentUser = user;
    yield* Firestore.instance
        .collection('User Management')
        .where('UserId', isEqualTo: currentUser.uid)
        .snapshots();
  }
}
