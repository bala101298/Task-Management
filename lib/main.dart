import 'package:flutter/material.dart';
import 'package:tasker/Pages/addTask.dart';
import 'package:tasker/Pages/home.dart';
import 'package:tasker/Pages/taskList.dart';
import 'package:tasker/Utils/Constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: kAppBarTheme,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => HomePage(),
        "/TaskList": (context) => TaskListPage(),
        "/AddTask": (context) => AddTaskPage(),
      },
    );
  }
}
