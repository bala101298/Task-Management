import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasker/services/database.dart';

QuerySnapshot usersnapshot;
List users;
int index;
bool isMe = false;
final _auth = FirebaseAuth.instance;
final _firestore = Firestore.instance;
String myName;
bool isSnap = false;
String user;
bool isLoading = false;
bool haveSearched = false;
QuerySnapshot searchResult;

class CustomDrawer extends StatefulWidget {
  CustomDrawer(
      {this.accountName,
      this.accountEmail,
      this.accountPicture,
      this.onTapLogout,
      this.accountid});
  final Widget accountName;
  final Widget accountEmail;
  final Widget accountPicture;
  final Function onTapLogout;
  final String accountid;

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    print(widget.accountid);
    setState(() {
      haveSearched = false;
    });
    super.initState();
  }

  initSearch() async {
    if (user != null) {
      setState(() {
        isLoading = true;
      });
      await Database().searchUser(user).then((snapshot) {
        searchResult = snapshot;
        print('$searchResult');
        setState(() {
          isLoading = false;
          haveSearched = true;
        });
      });
    }
  }

  userList() {
    return haveSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchResult.documents.length,
            itemBuilder: (context, int index) {
              return userCard(
                searchResult.documents[index].data['DisplayName'],
                searchResult.documents[index].data['Email'],
                searchResult.documents[index].data['UserId'],
                searchResult.documents[index].data['PhotoUrl'],
              );
            })
        : Container();
  }

  userCard(String displayname, String email, String uid, String photoUrl) {
    return Card(
      elevation: 1,
      child: Container(
        height: 60,
        width: 60,
        child: ListTile(
          title: Text(displayname),
          subtitle: Text(email),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                onPressed: () async {
                  final user = await FirebaseAuth.instance.currentUser();
                  setState(() {
                    Map<String, dynamic> requestdata = {
                      'DisplayName': user.displayName,
                      'Email': user.email,
                      'PhotoUrl': user.photoUrl,
                      'UserId': user.uid,
                    };
                    Database(uid: user.uid).sendFriendRequest(uid, requestdata);
                  });

                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text('Friend Request Sent'),
                    elevation: 1,
                    duration: Duration(seconds: 3),
                  ));
                  setState(() {
                    haveSearched = false;
                  });
                },
                icon: Icon(Icons.add),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: widget.accountName,
            accountEmail: widget.accountEmail,
            currentAccountPicture: widget.accountPicture,
          ),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search or Add Friends',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onChanged: (value) {
              setState(() {
                user = value;
              });
            },
          ),
          FlatButton(
            onPressed: () {
              initSearch();
            },
            child: Text('Search'),
          ),
          userList(),
          Friends(
            accountid: widget.accountid,
          ),
          FriendRequests(
            accountid: widget.accountid,
          ),
          GestureDetector(
            onTap: widget.onTapLogout,
            child: ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Logout"),
            ),
          ),
          SizedBox(height: 10),
          Center(child: Text("v-0.1.1 + 3"))
        ],
      ),
    );
  }
}

class FriendRequests extends StatefulWidget {
  final String accountid;
  FriendRequests({this.accountid});

  @override
  _FriendRequestsState createState() => _FriendRequestsState();
}

class _FriendRequestsState extends State<FriendRequests> {
  bool stopstream = false;
  QuerySnapshot friendrequestsnapshots;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
        onExpansionChanged: (value) {
          if (value == false) {
            setState(() {
              stopstream = true;
            });
          } else {
            setState(() {
              stopstream = false;
            });
          }
        },
        leading: Icon(Icons.people),
        title: Text("Friend Requests"),
        children: <Widget>[
          StreamBuilder(
              stream: stopstream ? null : friendreqstream(),
              builder: (context, snapshots) {
                if (!snapshots.hasData) {
                  return CircularProgressIndicator();
                }
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshots.data.documents.length,
                    itemBuilder: (context, int index) {
                      return ListTile(
                        title: Text(snapshots
                            .data.documents[index].data['DisplayName']),
                        trailing: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () async {
                            final user = await _auth.currentUser();
                            await Database(uid: widget.accountid)
                                .deleteFriendRequest(snapshots
                                    .data.documents[index].data['UserId']);
                            setState(() {
                              Map<String, dynamic> frienddata = {
                                'DisplayName': snapshots
                                    .data.documents[index].data['DisplayName'],
                                'Email': snapshots
                                    .data.documents[index].data['Email'],
                                'PhotoUrl': snapshots
                                    .data.documents[index].data['PhotoUrl'],
                                'UserId': snapshots
                                    .data.documents[index].data['UserId'],
                              };
                              Database(uid: widget.accountid).addFriend1(
                                snapshots.data.documents[index].data['UserId'],
                                frienddata,
                              );
                            });
                            setState(() {
                              Map<String, dynamic> mydata = {
                                'DisplayName': user.displayName,
                                'Email': user.email,
                                'PhotoUrl': user.photoUrl,
                                'UserId': user.uid,
                              };
                              Database(uid: widget.accountid).addFriend2(
                                  snapshots
                                      .data.documents[index].data['UserId'],
                                  mydata);
                            });
                          },
                        ),
                      );
                    });
              })
        ]);
  }

  Stream<QuerySnapshot> friendreqstream() async* {
    final user = await _auth.currentUser();

    FirebaseUser currentUser = user;
    print(currentUser.uid);
    yield* _firestore
        .collection('User_Management')
        .document(currentUser.uid)
        .collection('Friend Requests')
        .snapshots();
  }
}

class Friends extends StatefulWidget {
  final String accountid;
  Friends({this.accountid});

  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {
  bool stopstream = false;
  QuerySnapshot friendsnapshots;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      onExpansionChanged: (value) {
        if (value == false) {
          setState(() {
            stopstream = true;
          });
        } else {
          setState(() {
            stopstream = false;
          });
        }
      },
      leading: Icon(Icons.people),
      title: Text("Friends"),
      children: <Widget>[
        StreamBuilder(
          stream: stopstream ? null : friendstream(),
          builder: (context, snapshots) {
            if (!snapshots.hasData) {
              return CircularProgressIndicator();
            }
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshots.data.documents.length,
                itemBuilder: (context, int index) {
                  return ListTile(
                    title: Text(
                        snapshots.data.documents[index].data['DisplayName']),
                  );
                });
          },
        )
      ],
    );
  }

  Stream<QuerySnapshot> friendstream() async* {
    final user = await _auth.currentUser();

    FirebaseUser currentUser = user;
    print(currentUser.uid);
    yield* _firestore
        .collection('User_Management')
        .document(currentUser.uid)
        .collection('Friends')
        .snapshots();
  }
}
