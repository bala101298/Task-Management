import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasker/Pages/add_project.dart';
import 'package:tasker/Pages/project_workspace.dart';
import 'package:tasker/Widgets/projecthomecard.dart';
import 'package:tasker/Pages/newganttchart.dart';

class ProjectHome extends StatefulWidget {
  @override
  _ProjectHomeState createState() => _ProjectHomeState();
}

class _ProjectHomeState extends State<ProjectHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue[50],
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Dashboard',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: StreamBuilder(
              stream: getprojectstream(),
              builder: (context, snapshots) {
                if (!snapshots.hasData) {
                  return Container();
                }
                return ListView.builder(
                    itemCount: snapshots.data.documents.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          final user =
                              await FirebaseAuth.instance.currentUser();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProjectPage(
                                        projectname: snapshots
                                            .data
                                            .documents[index]
                                            .data['Project Name'],
                                        myname: user.displayName,
                                      )));
                        },
                        child: Projecthomecard(
                          projectname: snapshots
                              .data.documents[index].data['Project Name'],
                          members:
                              snapshots.data.documents[index].data['Members'],
                          createdon: snapshots
                              .data.documents[index].data['Created on'],
                          dateofsubmission: snapshots
                              .data.documents[index].data['Date of Completion'],
                        ),
                      );
                    });
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[500],
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddProjectPage()));
        },
        tooltip: 'Add Project',
        child: Icon(Icons.add),
      ),
    );
  }

  Stream<QuerySnapshot> getprojectstream() async* {
    final user = await FirebaseAuth.instance.currentUser();
    yield* Firestore.instance
        .collection('Projects')
        .where('Members', arrayContains: user.displayName)
        .snapshots();
  }
}
