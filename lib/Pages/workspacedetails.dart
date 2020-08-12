import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tasker/Pages/add_project.dart';
import 'package:tasker/Utils/constants.dart';
import 'package:tasker/services/database.dart';

String input;
String timestamp;

class WorkspaceDetails extends StatefulWidget {
  String projectname;
  String taskstamp;
  String taskname;
  WorkspaceDetails({this.projectname, this.taskstamp, this.taskname});
  @override
  _WorkspaceDetailsState createState() => _WorkspaceDetailsState();
}

class _WorkspaceDetailsState extends State<WorkspaceDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.blue[50],
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          widget.taskname,
          style: TextStyle(color: Colors.black),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: () {},
            tooltip: 'Chat with Assignor',
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(widget.taskstamp);
          showModalBottomSheet(
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              context: context,
              builder: (context) {
                return Padding(
                  padding: MediaQuery.of(context).viewInsets,
                  child: Container(
                    height: 150,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextFormField(
                            decoration:
                                InputDecoration(hintText: 'Enter SubTask'),
                            onChanged: (value) {
                              input = value;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          RaisedButton(
                            onPressed: () async {
                              setState(() {
                                timestamp = DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString();
                              });
                              if (input != null) {
                                print('Inside add');
                                await Database().addSubTask(widget.projectname,
                                    widget.taskstamp, input, timestamp);
                              }
                              setState(() {
                                input = null;
                              });

                              Navigator.pop(context);
                            },
                            child: Text('Add'),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
        child: Icon(Icons.add),
        tooltip: 'Add SubTasks',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: StreamBuilder(
          stream: getTasksStream(widget.projectname),
          builder: (context, snapshots) {
            if (!snapshots.hasData) {
              return Container();
            }
            return ListView(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(left: 30.0, top: 40, right: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Text(
                          'Task Description :',
                          style: kHeadingTextStyle,
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      Container(
                        child: Card(
                          color: Colors.blue[500],
                          elevation: 2,
                          shadowColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                snapshots
                                    .data.documents[0].data['Task Description'],
                                maxLines: null,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      Center(
                        child: Text(
                          'SubTasks :',
                          style: kHeadingTextStyle,
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.03,
                      ),
                      StreamBuilder(
                          stream: getSubTasksStream(
                              widget.projectname, widget.taskstamp),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Container();
                            }
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                      color: Colors.blue[500],
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      elevation: 2,
                                      child: ListTile(
                                        title: Center(
                                            child: Text(
                                          snapshot.data.documents[index]
                                              .data['SubTask'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )),
                                        trailing: IconButton(
                                          color: Colors.black,
                                          icon: Icon(Icons.delete),
                                          onPressed: () async {
                                            await Database().deleteSubTask(
                                                widget.projectname,
                                                widget.taskstamp,
                                                snapshot.data.documents[index]
                                                    .data['timestamp']);
                                            Scaffold.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text('Task Deleted'),
                                              duration: Duration(seconds: 3),
                                            ));
                                          },
                                        ),
                                      ));
                                });
                          }),
                      SizedBox(
                        height: screenHeight * 0.03,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }

  Stream<QuerySnapshot> getTasksStream(String projectname) async* {
    yield* Firestore.instance
        .collection('Projects')
        .document(projectname)
        .collection('Tasks')
        .snapshots();
  }

  Stream<QuerySnapshot> getSubTasksStream(
      String projectname, String timestamp) async* {
    yield* Firestore.instance
        .collection('Projects')
        .document(projectname)
        .collection('Tasks')
        .document(timestamp)
        .collection('SubTasks')
        .snapshots();
  }
}
