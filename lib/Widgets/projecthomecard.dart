import 'package:flutter/material.dart';

class Projecthomecard extends StatefulWidget {
  String projectname;
  String dateofsubmission;
  String createdon;
  List members;

  Projecthomecard(
      {this.projectname, this.createdon, this.dateofsubmission, this.members});
  @override
  _ProjecthomecardState createState() => _ProjecthomecardState();
}

class _ProjecthomecardState extends State<Projecthomecard> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(left: 10, top: 15),
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.orangeAccent,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.projectname,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: <Widget>[
                Container(
                  height: 40,
                  child: Row(
                    children: <Widget>[
                      Text(
                        'MEMBERS:',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 20),
                      Container(
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.members.length,
                            itemBuilder: (context, index) {
                              return Row(children: <Widget>[
                                Card(
                                  elevation: 0,
                                  color: Colors.orangeAccent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    widget.members[index],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                )
                              ]);
                            }),
                      )
                    ],
                  ),
                ),
              ]),
            ),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                Text(
                  'Date of Submission:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  widget.dateofsubmission,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: <Widget>[
                Text(
                  'Created On:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 10),
                Text(
                  widget.createdon,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
