import 'package:flutter/material.dart';
import 'package:tasker/Utils/Constants.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
           Navigator.pushNamed(context, "/AddTask");
        },
        child: Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(36.0),
        child: Container(
          child: Text(
            "Daily Task",
            style: kHeading2,
          ),
        ),
      ),
    );
  }
}
