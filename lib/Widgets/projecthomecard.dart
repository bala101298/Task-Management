import 'package:flutter/material.dart';
import 'package:tasker/Utils/constants.dart';
import 'package:tasker/services/database.dart';

String input;
bool projectdeleted = false;

class Projecthomecard extends StatefulWidget {
  String projectname;
  String dateofsubmission;
  String createdon;
  List members;

  Projecthomecard(
      {this.projectname, this.createdon, this.dateofsubmission, this.members});
  @override
  _ProjecthomecardState createState() => _ProjecthomecardState();
}

class _ProjecthomecardState extends State<Projecthomecard> {
  @override
  void initState() {
    setState(() {
      projectdeleted = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        color: Colors.blue[500],
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(widget.projectname,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('TASKER'),
                              content: Container(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      'To delete the project , kindly enter the project name in the given field below..',
                                      maxLines: null,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                        'Project name : ${widget.projectname}'),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    TextField(
                                      decoration: InputDecoration(
                                        hintText: 'Enter project name',
                                        hintStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          input = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                RaisedButton(
                                  onPressed: () async {
                                    if (input == widget.projectname) {
                                      await Database()
                                          .deleteproject(widget.projectname);
                                      Navigator.pop(context);
                                    } else {
                                      Text(
                                          'Please enter the correct project name..');
                                    }
                                  },
                                  child: Text('Confirm'),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel'),
                                )
                              ],
                            );
                          });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: <Widget>[
                  Container(
                    height: 40,
                    child: Row(
                      children: <Widget>[
                        Text(
                          'MEMBERS:',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 20),
                        Container(
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.members.length,
                              itemBuilder: (context, index) {
                                return Row(children: <Widget>[
                                  Card(
                                    elevation: 0,
                                    color: Colors.blue[500],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      widget.members[index],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  )
                                ]);
                              }),
                        )
                      ],
                    ),
                  ),
                ]),
              ),
              SizedBox(height: 20),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    Text(
                      'Date of Submission:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      widget.dateofsubmission,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Text(
                    'Created On:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10),
                  Text(
                    widget.createdon,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
