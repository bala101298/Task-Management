import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasker/Utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:tasker/services/database.dart';

String tasktitle;
String taskdes;
String defaultDate = new DateFormat.yMMMEd().format(DateTime.now());
String formatedDate;
DateTime duedate;
List assignedto = List();
bool memberselected = false;
int timestamp;

class AddAssignedTask extends StatefulWidget {
  String projectname;
  AddAssignedTask(this.projectname);

  @override
  _AddAssignedTaskState createState() => _AddAssignedTaskState();
}

class _AddAssignedTaskState extends State<AddAssignedTask> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime dateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (dateTime != null) {
      print(dateTime);
      setState(() {
        duedate = dateTime;
      });
    }
  }

  @override
  void initState() {
    assignedto.clear();
    duedate = null;
    print(assignedto.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(
          'Add Task',
          style: kHeadingTextStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Task Title:',
                style: kHeadingTextStyle,
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter the task title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onChanged: (value) {
                  tasktitle = value;
                },
              ),
              SizedBox(height: 20),
              Text(
                'Assigned to',
                style: kHeadingTextStyle,
              ),
              SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 50,
                      child: Row(
                        children: <Widget>[
                          StreamBuilder(
                            stream: getMembersStream(widget.projectname),
                            builder: (context, snapshots) {
                              if (!snapshots.hasData) {
                                return Container();
                              }
                              return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: snapshots
                                      .data.documents[0].data['Members'].length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          memberselected = !memberselected;
                                        });

                                        assignedto.add(snapshots
                                            .data
                                            .documents[0]
                                            .data['Members'][index]);
                                        print(assignedto.toString());
                                      },
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Center(
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                snapshots.data.documents[0]
                                                    .data['Members'][index],
                                                style: kHeading2,
                                              ),
                                              Container(
                                                  margin: EdgeInsets.all(5),
                                                  width: 24,
                                                  height: 24,
                                                  decoration: BoxDecoration(
                                                      //color: Colors.blueAccent,
                                                      /*border: Border.all(
                                                  color: Colors.black87,
                                                  width: 1),*/
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30)),
                                                  child: Center(
                                                      child: memberselected
                                                          ? Icon(Icons
                                                              .check_circle)
                                                          : Container()))
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Task Description: (Optional)',
                style: kHeadingTextStyle,
              ),
              SizedBox(height: 20),
              TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Enter the Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    taskdes = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Text(
                'Due Date',
                style: kHeadingTextStyle,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      width: 250,
                      child: duedate != null
                          ? Text(duedate.toString())
                          : Text(
                              'Selected Date',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            )),
                  SizedBox(width: screenwidth * 0.01),
                  IconButton(
                    icon: Icon(Icons.date_range),
                    onPressed: () async {
                      await _selectDate(context);
                      setState(() {
                        //duedate = formatedDate;
                      });
                    },
                  )
                ],
              ),
              SizedBox(height: 40),
              Center(
                child: MaterialButton(
                  minWidth: 20,
                  onPressed: () async {
                    setState(() {
                      timestamp = DateTime.now().millisecondsSinceEpoch;
                    });
                    print('Members inside onpressed ${assignedto.toString()}');
                    await Database().addassignedTask(
                        widget.projectname,
                        timestamp.toString(),
                        assignedto,
                        duedate,
                        tasktitle,
                        taskdes);
                    assignedto.clear();
                    duedate = null;
                    Navigator.pop(context);
                  },
                  color: Colors.greenAccent,
                  textColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Confirm',
                    style: kHeadingTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Stream<QuerySnapshot> getMembersStream(String projectname) async* {
    yield* Firestore.instance
        .collection('Projects')
        .where('Project Name', isEqualTo: projectname)
        .snapshots();
  }
}
