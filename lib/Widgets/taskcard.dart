import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasker/Pages/addTask.dart';
import 'package:tasker/services/auth.dart';
import 'package:tasker/services/database.dart';

Authentication authentication = Authentication();
bool edittask = true;

class TaskCard extends StatefulWidget {
  TaskCard(
      {this.task,
      this.timestamp,
      this.taskCompleted,
      this.dueDate,
      this.priority});
  final String task;
  final String timestamp;
  bool taskCompleted;
  final String dueDate;
  int priority;

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.0,
      child: Container(
        width: 60,
        height: 60,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Container(
                width: 15,
                color: taskcolor(
                    priority: widget.priority,
                    taskcompleted: widget.taskCompleted),
              ),
              GestureDetector(
                onTap: () async {
                  final user = await FirebaseAuth.instance.currentUser();
                  setState(() {
                    if (widget.taskCompleted == false) {
                      widget.taskCompleted = true;
                    } else {
                      widget.taskCompleted = false;
                    }
                    Database(uid: user.uid).addTask(
                        timestamp: widget.timestamp,
                        taskCompleted: widget.taskCompleted,
                        input: widget.task,
                        selectedDate: widget.dueDate,
                        priority: widget.priority);
                  });
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black87, width: 1),
                      borderRadius: BorderRadius.circular(30)),
                  child: widget.taskCompleted == true
                      ? Icon(
                          Icons.check,
                          color: Colors.green,
                        )
                      : Container(),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Spacer(),
              Flexible(
                fit: FlexFit.tight,
                flex: 50,
                child: Text(
                  widget.task,
                  maxLines: null,
                  style: TextStyle(
                      color: widget.taskCompleted == false
                          ? Colors.black
                          : Colors.black54.withOpacity(0.7),
                      fontSize: 17,
                      decoration: widget.taskCompleted == true
                          ? TextDecoration.lineThrough
                          : TextDecoration.none),
                ),
              ),
              Spacer(),
              widget.taskCompleted == true
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddTaskPage(
                              edittask: edittask,
                              newTask: widget.task,
                              edittimestamp: widget.timestamp,
                              priority: widget.priority,
                            ),
                          ),
                        );
                      },
                      child: Icon(Icons.edit,
                          size: 25, color: Colors.black87.withOpacity(0.7)),
                    ),
              SizedBox(width: 10.0),
              GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Warning!"),
                        content: Text("Do you want to delete this task ?"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("Yes"),
                            onPressed: () async {
                              final user =
                                  await FirebaseAuth.instance.currentUser();
                              Navigator.pop(context);
                              Database(uid: user.uid)
                                  .deleteTask(widget.timestamp);
                            },
                          ),
                          FlatButton(
                            child: Text("No"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Icon(Icons.delete,
                    size: 25, color: Colors.black87.withOpacity(0.7)),
              )
            ],
          ),
        ),
      ),
    );
  }
}

taskcolor({int priority, bool taskcompleted}) {
  if (taskcompleted == false) {
    if (priority == 0) {
      return Colors.yellow;
    } else if (priority == 1) {
      return Colors.green;
    } else if (priority == 2) {
      return Colors.red;
    }
  } else {
    return Colors.grey;
  }
}
