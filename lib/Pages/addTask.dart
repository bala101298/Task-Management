import 'package:flutter/material.dart';
import 'package:tasker/Utils/constants.dart';
import 'package:tasker/Widgets/taskField.dart';

class AddTaskPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: FlatButton(color: Colors.grey, onPressed: () {}, child: Text("Done")),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(36),
              alignment: Alignment.bottomLeft,
              color: Colors.white,
              child: Text(
                "Personal Task",
                style: kHeading3,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Task Name",
                    style: kHeading2,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  TaskTextField(hintText: "What's on your mind"),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    "Due Date",
                    style: kHeading2,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  FlatButton(
                      color: Colors.grey,
                      onPressed: () {},
                      child: Text("Set Date and Time")),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    "Description",
                    style: kHeading2,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  TaskTextField(hintText: "Let us know"),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
