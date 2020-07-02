import 'package:flutter/material.dart';

class ContainerCard extends StatelessWidget {
  ContainerCard({this.onTap, this.height, this.color, this.child});
  final Function onTap;
  final double height;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomLeft,
        width: 150,
        height: height,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(10)),
        child: child,
      ),
    );
  }
}
