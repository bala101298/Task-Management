import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tasker/Pages/addTask.dart';
import 'package:tasker/Pages/home.dart';
import 'package:tasker/Pages/sign_in.dart';
import 'package:tasker/Pages/taskList.dart';
import 'package:tasker/Utils/Constants.dart';
import 'package:tasker/services/auth.dart';

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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('es', ''),
        const Locale('en', ''),
      ],
      initialRoute: "/initialroute",
      routes: {
        "/home": (context) => HomePage(),
        "/TaskList": (context) => TaskListPage(),
        "/AddTask": (context) => AddTaskPage(),
        "/signin": (context) => SignInPage(),
        "/initialroute": (context) => LoginorHome(),
      },
    );
  }
}

class LoginorHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Authentication().user,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool isLoggedIn = snapshot.hasData;
          print(isLoggedIn);
          return isLoggedIn ? HomePage() : SignInPage();
        }
        return CircularProgressIndicator();
      },
    );
  }
}
