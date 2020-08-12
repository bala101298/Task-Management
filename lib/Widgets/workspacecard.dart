import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasker/Pages/workspacedetails.dart';
import 'package:tasker/Utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tasker/services/database.dart';

String taskstamp;
bool isMe = true;

class WorkspaceCard extends StatefulWidget {
  String projectname;
  String myname;
  WorkspaceCard({this.projectname, this.myname});
  @override
  _WorkspaceCardState createState() => _WorkspaceCardState();
}

class _WorkspaceCardState extends State<WorkspaceCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: getTasksStream(widget.projectname),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                if (snapshot.data.documents[index].data['Assignor'] ==
                    widget.myname) {
                  isMe = true;
                } else {
                  isMe = false;
                }
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WorkspaceDetails(
                                  projectname: widget.projectname,
                                  taskstamp: snapshot
                                      .data.documents[index].data['timestamp'],
                                  taskname: snapshot
                                      .data.documents[index].data['Task'],
                                )));
                  },
                  child: Card(
                    elevation: 2,
                    color:
                        isMe ? Colors.blue[500] : Colors.deepOrangeAccent[200],
                    shape: RoundedRectangleBorder(
                        borderRadius: isMe
                            ? BorderRadius.only(
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25),
                                topLeft: Radius.circular(25))
                            : BorderRadius.only(
                                bottomLeft: Radius.circular(25),
                                bottomRight: Radius.circular(25),
                                topRight: Radius.circular(25))),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        //border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                snapshot.data.documents[index].data['Assignor'],
                                style: kHeadingTextStyle,
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text(
                                            'Tasker',
                                            style: kHeading2,
                                          ),
                                          content: Text(
                                            'Do you want to delete the task ?',
                                            style: kHeading2,
                                          ),
                                          actions: <Widget>[
                                            RaisedButton(
                                              onPressed: () async {
                                                setState(() {
                                                  taskstamp = snapshot
                                                      .data
                                                      .documents[index]
                                                      .data['timestamp'];
                                                });
                                                await Database()
                                                    .deleteassignedTask(
                                                        taskstamp,
                                                        widget.projectname);
                                                Navigator.pop(context);
                                              },
                                              child: Text('Yes'),
                                            ),
                                            FlatButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('No'),
                                            )
                                          ],
                                        );
                                      });
                                },
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Task: ${snapshot.data.documents[index].data['Task']}',
                            style: kHeadingTextStyle,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Assigned to: ${snapshot.data.documents[index].data['Assigned To'].toString()}',
                            style: kHeadingTextStyle,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Due Date: ${snapshot.data.documents[index].data['Due Date']}',
                            style: kHeadingTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
  }

  Stream<QuerySnapshot> getTasksStream(String projectname) async* {
    yield* Firestore.instance
        .collection('Projects')
        .document(projectname)
        .collection('Tasks')
        .snapshots();
  }
}
