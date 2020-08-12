import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasker/Pages/add_assigntask_page.dart';
import 'package:tasker/Utils/constants.dart';
import 'package:tasker/Widgets/workspacecard.dart';
import 'package:tasker/Pages/newganttchart.dart';
import 'package:tasker/services/database.dart';

List members = List();
final _firestore = Firestore.instance;
final _auth = FirebaseAuth.instance;

class ProjectPage extends StatefulWidget {
  String projectname;
  String myname;
  ProjectPage({this.projectname, this.myname});

  @override
  _ProjectPageState createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  Stream<QuerySnapshot> membersstream() async* {
    yield* _firestore
        .collection('Projects')
        .where('Project Name', isEqualTo: widget.projectname)
        .snapshots();
  }

  Stream<QuerySnapshot> friendstream() async* {
    final user = await _auth.currentUser();

    FirebaseUser currentUser = user;
    print(currentUser.uid);
    yield* _firestore
        .collection('User_Management')
        .document(currentUser.uid)
        .collection('Friends')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.blue[50],
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: GestureDetector(
          onTap: () {
            //Todo > Project Details
          },
          child: Text(
            widget.projectname,
            style: TextStyle(color: Colors.black),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.show_chart),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return NewGanttChart(
                  projectname: widget.projectname,
                );
              }));
            },
          ),
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return StreamBuilder(
                          stream: friendstream(),
                          builder: (context, snapshots) {
                            if (!snapshots.hasData) {
                              return Container();
                            }
                            return StreamBuilder(
                                stream: membersstream(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Container();
                                  }
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount:
                                          snapshots.data.documents.length,
                                      itemBuilder: (context, index) {
                                        members = snapshot
                                            .data.documents[0].data['Members'];
                                        print(members);
                                        return Card(
                                            borderOnForeground: true,
                                            elevation: 0,
                                            child: GestureDetector(
                                              onTap: () async {
                                                if (members.contains(snapshots
                                                    .data
                                                    .documents[index]
                                                    .data['DisplayName'])) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return AlertDialog(
                                                          content: Text(
                                                              'Member already added'),
                                                          actions: [
                                                            RaisedButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text('Ok'),
                                                            )
                                                          ],
                                                        );
                                                      });
                                                } else {
                                                  members.add(snapshots
                                                      .data
                                                      .documents[index]
                                                      .data['DisplayName']);
                                                  await Database()
                                                      .updatemembers(members,
                                                          widget.projectname);
                                                }
                                              },
                                              child: ListTile(
                                                title: Text(snapshots
                                                    .data
                                                    .documents[index]
                                                    .data['DisplayName']),
                                              ),
                                            ));
                                      });
                                });
                          });
                    });
              })
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blue[500],
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddAssignedTask(widget.projectname)));
        },
      ),
      body: StreamBuilder(
          stream: getprojectstream(widget.projectname),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            }
            return Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 40, right: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Project Head:    ${snapshot.data.documents[0].data['Admin']}', // add $variable instead of name
                    style: kHeadingTextStyle,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Total Members:   ${snapshot.data.documents[0].data['Members'].length}',
                    style: kHeadingTextStyle,
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: WorkspaceCard(
                      projectname: widget.projectname,
                      myname: widget.myname,
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  Stream<QuerySnapshot> getprojectstream(String projectname) async* {
    yield* Firestore.instance
        .collection('Projects')
        .where('Project Name', isEqualTo: projectname)
        .snapshots();
  }
}
