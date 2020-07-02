import 'package:flutter/material.dart';

class TaskTextField extends StatelessWidget {
  TaskTextField({this.hintText});
  final String hintText;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        minLines: 1,
        maxLines: 2,
        autocorrect: false,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: Color(0x32707070),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Color(0x32707070)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}
