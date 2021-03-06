import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tasker/services/database.dart';

String projectname;
final _firestore = Firestore.instance;
final _auth = FirebaseAuth.instance;
String projectdescription;
String startdate;
String enddate;
String formatedDate;
String defaultDate = new DateFormat.yMMMEd().format(DateTime.now());
QuerySnapshot snapshot;
List members = List();
bool userselected = false;
bool showcontacts = false;
bool membersselected = false;
bool checked = false;

class AddProjectPage extends StatefulWidget {
  @override
  _AddProjectPageState createState() => _AddProjectPageState();
}

class _AddProjectPageState extends State<AddProjectPage> {
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
        formatedDate = new DateFormat.yMMMEd().format(dateTime);
      });
    }
  }

  @override
  void initState() {
    setState(() {
      showcontacts = false;
      startdate = null;
      enddate = null;
    });
    members.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'ADD PROJECT',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: ListView(children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                child: Text(
                  'Project Name:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter Project Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    projectname = value;
                  });
                },
              ),
              SizedBox(height: 40),
              Container(
                child: Text(
                  'Add Members:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(height: 20),
              MaterialButton(
                onPressed: () async {
                  setState(() {
                    showcontacts = true;
                  });
                },
                color: Colors.greenAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('Add'),
              ),
              showcontacts
                  ? StreamBuilder(
                      stream: friendstream(),
                      builder: (context, snapshots) {
                        if (!snapshots.hasData) {
                          return Container();
                        }
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshots.data.documents.length,
                            itemBuilder: (context, index) {
                              return Card(
                                  borderOnForeground: true,
                                  elevation: 0,
                                  child: GestureDetector(
                                    onTap: () {
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
                                                      Navigator.pop(context);
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
                                        setState(() {
                                          membersselected = true;
                                        });
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
                      })
                  : Container(),
              Text(
                'Project Description',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Project Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onChanged: (value) {
                  projectdescription = value;
                },
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                child: Text(
                  'Start Date:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      width: 220,
                      height: 40,
                      child: startdate != null
                          ? Text(startdate)
                          : Text(
                              'Selected Date',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            )),
                  SizedBox(
                    width: screenwidth * 0.01,
                  ),
                  IconButton(
                    icon: Icon(Icons.date_range),
                    onPressed: () async {
                      await _selectDate(context);
                      setState(() {
                        startdate = formatedDate;
                      });
                      print(startdate);
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                child: Text(
                  'End Date :',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                      width: 220,
                      height: 40,
                      child: enddate != null
                          ? Text(enddate)
                          : Text(
                              'Selected Date',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            )),
                  SizedBox(
                    width: screenwidth * 0.01,
                  ),
                  IconButton(
                    icon: Icon(Icons.date_range),
                    onPressed: () async {
                      await _selectDate(context);
                      setState(() {
                        enddate = formatedDate;
                      });
                      print('End date : $enddate');
                      print('Start date : $startdate');
                    },
                  ),
                ],
              ),
              SizedBox(height: 40),
              MaterialButton(
                minWidth: 20,
                onPressed: () async {
                  final user = await _auth.currentUser();
                  members.add(user.displayName);
                  setState(() {
                    showcontacts = false;
                  });
                  setState(() {
                    membersselected = false;
                  });
                  await Database().addproject(
                      projectname,
                      projectdescription,
                      formatedDate,
                      startdate,
                      defaultDate,
                      members,
                      user.displayName);
                  members.clear();
                  startdate = null;
                  enddate = null;
                  Navigator.pushReplacementNamed(context, '/projecthome');
                },
                color: Colors.greenAccent,
                textColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Confirm',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
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
}
