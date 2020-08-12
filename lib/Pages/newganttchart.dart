import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_utils/date_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DateTime fromDate = DateTime(2020, 7, 1);
DateTime toDate = DateTime(2021);
int viewRangeToFitScreen = 6;

class NewGanttChart extends StatefulWidget {
  String projectname;
  NewGanttChart({this.projectname});
  @override
  _NewGanttChartState createState() => _NewGanttChartState();
}

class _NewGanttChartState extends State<NewGanttChart> {
  @override
  Widget build(BuildContext context) {
    //main build function
    var screenwidth = MediaQuery.of(context).size.width;
    var screenheight = MediaQuery.of(context).size.height;
    var screenOrientation = MediaQuery.of(context).orientation;

    screenOrientation == Orientation.landscape
        ? viewRangeToFitScreen = 12
        : viewRangeToFitScreen = 6;
    return SafeArea(
      child: Scaffold(
          body: ListView(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[ganttchart(screenheight, screenwidth)],
      )),
    );
  }

  Widget buildGrid(double chartViewWidth) {
    //function to print grid lines
    List<Widget> gridColumns = new List();
    int viewRange = calculateNumberOfMonthsBetween(fromDate, toDate);
    var numofdays = Utils.lastDayOfMonth(
        fromDate); //to calculate number of days of particular month

    for (int i = 0; i <= viewRange; i++) {
      for (int j = 1; j <= numofdays.day; j++) {
        gridColumns.add(Container(
          decoration: BoxDecoration(
              border: Border(
                  right: BorderSide(
                      color: Colors.grey.withAlpha(100), width: 1.0))),
          width: i == 0 && j == 1
              ? chartViewWidth * 0.5
              : chartViewWidth / viewRangeToFitScreen,
        ));
      }
    }

    return Row(
      children: gridColumns,
    );
  }

  Widget ganttchart(var screenheight, var screenwidth) {
    //function to print all the necessary for gantt chart
    double width = screenwidth / viewRangeToFitScreen * 200;
    print(width);
    return Container(
      height: screenheight,
      child: ListView(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Stack(
            fit: StackFit.loose,
            children: <Widget>[
              buildGrid(screenwidth), //grid display
              printmonths(screenwidth), //dates display
              Container(
                  margin: EdgeInsets.only(top: screenheight * 0.15),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                StreamBuilder(
                                    //stream pointing to Tasks subcollection inside Project collection
                                    stream: projectstream(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Container();
                                      }
                                      return Container(
                                        //color: Colors.redAccent,
                                        width: screenwidth * 0.5,
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount:
                                                snapshot.data.documents.length,
                                            itemBuilder: (context, index) {
                                              return ListTile(
                                                title: Text(
                                                  snapshot.data.documents[index]
                                                      .data['Project Name'],
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              );
                                            }),
                                      );
                                    }),
                                StreamBuilder(
                                    stream: projectstream(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return Container();
                                      }

                                      return Container(
                                        width: width,
                                        child: ListView.separated(
                                            separatorBuilder:
                                                (context, index) => Divider(
                                                      color: Colors.black,
                                                    ),
                                            shrinkWrap: true,
                                            itemCount: snapshot
                                                .data
                                                .documents[0]
                                                .data['Members']
                                                .length,
                                            itemBuilder: (context, index1) {
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Container(
                                                    width: screenwidth * 0.5,
                                                    child: ListTile(
                                                      title: Text(
                                                          snapshot
                                                                  .data
                                                                  .documents[0]
                                                                  .data['Members']
                                                              [index1],
                                                          textAlign:
                                                              TextAlign.center,
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                    ),
                                                  ),
                                                  StreamBuilder(
                                                      //stream pointing to Tasks of individual members
                                                      stream: stream(snapshot
                                                              .data
                                                              .documents[0]
                                                              .data['Members']
                                                          [index1]),
                                                      builder:
                                                          (context, chartsnap) {
                                                        if (!chartsnap
                                                            .hasData) {
                                                          return Container();
                                                        }
                                                        var chartbars =
                                                            buildChartBars(
                                                                chartsnap,
                                                                screenwidth);
                                                        return Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children:
                                                                chartbars);
                                                      }),
                                                ],
                                              );
                                            }),
                                      );
                                    }),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget printmonths(double chartViewWidth) {
    //function to print dates
    //chartViewWidth = screenwidth
    int viewRange = calculateNumberOfMonthsBetween(fromDate, toDate);
    List<Widget> headerItems = new List();

    DateTime tempDate = fromDate;

    headerItems.add(Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: Container(
            width: chartViewWidth * 0.3,
            padding: const EdgeInsets.all(25.0),
            child: new Text(
              'NAME',
              textAlign: TextAlign.center,
              style: TextStyle(),
            ),
          ),
        ),
        SizedBox(
          width: chartViewWidth * 0.085,
        )
      ],
    ));
    for (int i = 1; i < viewRange; i++) {
      var numofdays = Utils.lastDayOfMonth(tempDate);
      for (int j = 1; j <= numofdays.day; j++) {
        headerItems.add(Row(
          children: <Widget>[
            new Container(
              width: chartViewWidth / viewRangeToFitScreen,
              child: Padding(
                padding: const EdgeInsets.only(top: 15.0, left: 20),
                child: Column(
                  children: <Widget>[
                    Text(
                      DateFormat.MMM().format(tempDate) +
                          '/' +
                          tempDate.year.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      DateFormat.E().format(tempDate),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      j.toString(),
                      style: TextStyle(fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
      }
      tempDate = Utils.nextMonth(tempDate);
    }

    return Container(
      color: Colors.white.withAlpha(100),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: headerItems,
      ),
    );
  }

  List<Widget> buildChartBars(AsyncSnapshot data, double chartViewWidth) {
    //function to build chart bars for each member
    //AsyncSnapshot data contains snapshots of individual members
    List<Widget> chartBars = new List();
    //print('${data.data.documents.length} tasks');
    for (int i = 0; i < data.data.documents.length; i++) {
      Timestamp st = data.data.documents[i].data['Start Date'];
      Timestamp end = data.data.documents[i].data['Due Date'];
      DateTime start = st.toDate();
      DateTime enddate = end.toDate();
      //print(start.toString());
      //print(enddate.toString());
      //print(data.data.documents[i].data['Task']);
      // print(calculateDistanceToLeftBorder(start) *
      // chartViewWidth /
      // viewRangeToFitScreen);
      var remainingWidth = calculateRemainingWidth(start, enddate);
      chartBars.add(new Container(
        decoration: BoxDecoration(
            color: Colors.blue.withAlpha(100),
            borderRadius: BorderRadius.circular(10.0)),
        height: 25.0,
        width: remainingWidth * chartViewWidth / viewRangeToFitScreen,
        margin: EdgeInsets.only(
            left: calculateDistanceToLeftBorder(start) *
                chartViewWidth /
                viewRangeToFitScreen,
            top: i == 0 ? 4.0 : 2.0,
            bottom: i == data.data.documents.length - 1 ? 4.0 : 2.0),
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            data.data.documents[i].data['Task'],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 10.0),
          ),
        ),
      ));
    }
    return chartBars;
  }

  int calculateNumberOfMonthsBetween(DateTime from, DateTime to) {
    //to calculate number of months between start date and end date
    return to.month - from.month + 12 * (to.year - from.year) + 1;
  }

  int calculateRemainingWidth(
      //to calculate the length of eacj chart bar
      DateTime projectStartedAt,
      DateTime projectEndedAt) {
    int viewRange =
        calculateNumberOfMonthsBetween(projectStartedAt, projectEndedAt);
    var numofdays = projectEndedAt.day - projectStartedAt.day;
    int projectLength =
        calculateNumberOfMonthsBetween(projectStartedAt, projectEndedAt);
    print(projectLength);
    if (projectStartedAt.compareTo(fromDate) >= 0 &&
        projectStartedAt.compareTo(toDate) <= 0) {
      if (projectLength <= viewRange)
        return projectLength * numofdays;
      else
        return viewRange * numofdays -
            calculateNumberOfMonthsBetween(fromDate, projectStartedAt);
    } else if (projectStartedAt.isBefore(fromDate) &&
        projectEndedAt.isBefore(fromDate)) {
      return 0;
    } else if (projectStartedAt.isBefore(fromDate) &&
        projectEndedAt.isBefore(toDate)) {
      return projectLength * numofdays -
          calculateNumberOfMonthsBetween(projectStartedAt, fromDate);
    } else if (projectStartedAt.isBefore(fromDate) &&
        projectEndedAt.isAfter(toDate)) {
      return viewRange * numofdays;
    }
    return 0;
  }

  int calculateDistanceToLeftBorder(DateTime projectStartedAt) {
    //to calculate distance of each bar from left border
    if (projectStartedAt.compareTo(fromDate) <= 0) {
      print('Inside 0');
      return 0;
    } else {
      int days = projectStartedAt.difference(fromDate).inDays;
      print('Inside 1');
      print(days);
      return days;
    }
  }

  Stream<QuerySnapshot> stream(String name) async* {
    final user = await FirebaseAuth.instance.currentUser();

    FirebaseUser currentUser = user;
    print(currentUser.uid);
    yield* Firestore.instance
        .collection('Projects')
        .document(widget.projectname)
        .collection('Tasks')
        .where('Assigned To', arrayContains: name)
        .snapshots();
  }

  Stream<QuerySnapshot> projectstream() async* {
    yield* Firestore.instance
        .collection('Projects')
        .where('Project Name', isEqualTo: widget.projectname)
        .snapshots();
  }
}
