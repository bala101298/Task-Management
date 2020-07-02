import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  TaskTile({this.title, this.subtitle});
  final Widget title;
  final Widget subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: GestureDetector(
        child: ListTile(
          leading: leadingIcon(),
          title: title,
          subtitle: subtitle,
        ),
      ),
    );
  }
}

Widget leadingIcon() {
  return Container(
      margin: EdgeInsets.all(5),
      width: 25,
      height: 25,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.deepPurpleAccent, width: 2),
          borderRadius: BorderRadius.circular(10)),
      child: Container()
// TODO: onChange tick function
      );
}
