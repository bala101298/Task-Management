import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasker/Pages/sign_in.dart';
import 'package:tasker/Utils/constants.dart';
import 'package:tasker/services/auth.dart';
import 'package:tasker/services/database.dart';
import 'package:intl/intl.dart';

final _formkey = GlobalKey<FormState>();
String input;
String formatedDate;
String defaultDate = new DateFormat.yMMMEd().format(DateTime.now());
String timestamp;
Authentication authentication = Authentication();

class AddTaskPage extends StatefulWidget {
  AddTaskPage({this.edittask, this.edittimestamp, this.newTask, this.priority});
  final String edittimestamp;
  final String newTask;
  bool edittask;
  int priority;
  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime dateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (dateTime != null) {
      setState(() {
        formatedDate = new DateFormat.yMMMEd().format(dateTime);
        print(formatedDate);
      });
    }
  }

  var priority = ["Low", "Medium", "High"];
  var currentItemSelected = "Low";
  int currentItemIndex = 1;

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black54),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Padding(
          padding:
              const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Text(
                    "Task Details",
                    style: kHeading2,
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Text(
                  "Task name:",
                  style: kBody_1.copyWith(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      input = value;
                    });
                  },
                  initialValue: widget.newTask,
                  validator: (value) {
                    if (value.length < 1) {
                      return "Cannot add empty task";
                    } else if (value.length > 45) {
                      return "Length of task cannot be greater than 45 characters";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "What's in your mind?",
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Text(
                  "Priority:",
                  style: kBody_1.copyWith(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                DropdownButton<String>(
                  value: widget.priority == null
                      ? priority[0]
                      : priority[widget.priority],
                  items: priority.map((String dropDownItem) {
                    return DropdownMenuItem(
                      value: dropDownItem,
                      child: Text(dropDownItem),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      currentItemSelected = value;
                      if (currentItemSelected == "Low") {
                        setState(() {
                          widget.priority = 0;
                        });
                      } else if (currentItemSelected == "Medium") {
                        setState(() {
                          widget.priority = 1;
                        });
                      } else if (currentItemSelected == "High") {
                        setState(() {
                          widget.priority = 2;
                        });
                      }
                      print(currentItemSelected);
                      print(widget.priority);
                    });
                  },
                ),
                SizedBox(height: screenHeight * 0.03),
                Text(
                  "Due Date:",
                  style: kBody_1.copyWith(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      InkWell(
                        child: Text(
                            formatedDate != null ? formatedDate : defaultDate,
                            textAlign: TextAlign.center,
                            style: kBody_2.copyWith(fontSize: 20)),
                        onTap: () {
                          _selectDate(context);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () {
                          _selectDate(context);
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Center(
                  child: RaisedButton(
                    onPressed: () async {
                      if (_formkey.currentState.validate()) {
                        timestamp =
                            DateTime.now().microsecondsSinceEpoch.toString();
                        print(input);
                        addTask(input);
                      }
                      input = null;
                    },
                    color: Colors.blue[500],
                    textColor: Colors.white,
                    child: Text("Add"),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                Text(
                  "Note: \n\n 1. Due date for task cannot be assigned in past. \n\n 2. If due date is not selected, today's date will be considered as default date.\n\n 3. Priority will be set to low in default state",
                  style: kBody_2.copyWith(color: Colors.grey, fontSize: 15),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addTask(String input) async {
    final user = await FirebaseAuth.instance.currentUser();
    if (widget.edittask == null) {
      print('Inside widget.edittask == null');
      Database(uid: user.uid).addTask(
          input: input,
          taskCompleted: false,
          timestamp: timestamp,
          priority: widget.priority != null ? widget.priority : 0,
          selectedDate: formatedDate != null ? formatedDate : defaultDate);

      Navigator.of(context).pop();
    } else if (input == null) {
      print('Inside input == null');
      Database(uid: user.uid).addTask(
          timestamp: widget.edittimestamp,
          taskCompleted: false,
          input: widget.newTask,
          priority: widget.priority != null ? widget.priority : 0,
          selectedDate: formatedDate != null ? formatedDate : defaultDate);
      Navigator.of(context).pop();
    } else {
      Database(uid: user.uid).addTask(
          timestamp: widget.edittimestamp,
          taskCompleted: false,
          input: input,
          priority: widget.priority != null ? widget.priority : 0,
          selectedDate: formatedDate != null ? formatedDate : defaultDate);
      Navigator.of(context).pop();
    }
  }
}
