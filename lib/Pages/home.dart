import 'package:flutter/material.dart';
import 'package:tasker/Utils/Constants.dart';
import 'package:tasker/Widgets/card.dart';
import 'package:tasker/Widgets/taskTile.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: screenHeight * 0.05),
                      Text(
                        "Hello",
                        style: kHeading1,
                      ),
                      //TODO: Add username from database below
                      Text(
                        "Ajay Vaidhyanathan",
                        style: kHeading2,
                      ),
                    ],
                  ),
                  CircleAvatar(
                    minRadius: 30,
                    maxRadius: 40,
                    //TODO: Add Userimage from database below
                    backgroundImage: AssetImage("images/photo.jpeg"),
                  )
                ],
              ),
              SizedBox(height: screenHeight * 0.05),
              ContainerCard(
                onTap: (){
                  Navigator.pushNamed(context, "/TaskList");
                },
                child: Text("Personal"),
                color: Colors.red[200],
                height: 150,
              ),
              SizedBox(height: screenHeight * 0.05),
              Text(
                "Today's Tasks",
                style: kHeading2,
              ),
              SizedBox(height: screenHeight * 0.02),
              //TODO : Add streambuilder below for tasks. Widget is in taskTile.dart
              TaskTile(
                title: Text("Buy milk"),
                subtitle: Text("10:00am"),
              ),
              TaskTile(
                title: Text("Call Balaji"),
                subtitle: Text("12:00pm"),
              ),
              TaskTile(
                title: Text("Meeting"),
                subtitle: Text("1:00pm"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
