import 'package:flutter/material.dart';
import 'package:tasker/Utils/constants.dart';
import 'package:tasker/services/auth.dart';

Authentication authentication = Authentication();

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: Padding(
          padding:
              const EdgeInsets.only(left: 30, right: 30, top: 30, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: screenHeight * 0.05),
              Text(
                "Welcome",
                style: kHeading1,
              ),
              SizedBox(height: screenHeight * 0.05),
              Text(
                "Hey Chief! You are few \nclicks away!",
                style: kBody_1,
              ),
              SizedBox(height: screenHeight * 0.1),
              Center(
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      color: Colors.white),
                  child: MaterialButton(
                    splashColor: Colors.grey,
                    onPressed: () {
                      authentication.signInWithGoogle(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(width: 10),
                          /*Image(
                              image: AssetImage("images/google_logo.png"),
                              height: 20.0),*/
                          SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Sign in with Google',
                              style:
                                  kBody_2.copyWith(fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.1),
              Center(
                  child: Text(
                "Version 0.1.1 + 3",
                style: kBody_2.copyWith(
                  color: Colors.white70,
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
