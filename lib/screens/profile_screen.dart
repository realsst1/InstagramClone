import 'package:flutter/material.dart';
import 'package:insta_clone/models/user_model.dart';
import 'package:insta_clone/screens/edit_profile_screen.dart';
import 'package:insta_clone/utilities/constants.dart';

class ProfileScreen extends StatefulWidget {

  final String userID;

  ProfileScreen({this.userID});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: usersRef.document(widget.userID).get(),
        builder: (BuildContext context,AsyncSnapshot snapshot) {
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator());
          }
          User user=User.fromDoc(snapshot.data);
          print(user.name);
          return ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50.0,
                      backgroundImage: NetworkImage(
                          'http://p.imgci.com/db/PICTURES/CMS/289000/289002.1.jpg'
                      ),
                    ),
                    SizedBox(width: 20.0,),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    "12",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  Text(
                                    "posts",
                                    style: TextStyle(
                                        color: Colors.black54
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    "12",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  Text(
                                    "followers",
                                    style: TextStyle(
                                        color: Colors.black54
                                    ),
                                  )
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    "12",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w600
                                    ),
                                  ),
                                  Text(
                                    "following",
                                    style: TextStyle(
                                        color: Colors.black54
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          Container(
                            width: 200.0,
                            child: FlatButton(
                              onPressed: () =>Navigator.push(context, MaterialPageRoute(builder: (_)=>EditProfileScreen(user:user))),
                              color: Colors.blue,
                              textColor: Colors.white,
                              child: Text(
                                "Edit Profile",
                                style: TextStyle(
                                    fontSize: 16.0
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      user.name,
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: 5.0,),
                    Container(
                      height: 80.0,
                      child: Text(
                        user.bio,
                        style: TextStyle(
                            fontSize: 15.0
                        ),
                      ),
                    ),
                    Divider()
                  ],
                ),
              )
            ],
          );
        }
      )
    );
  }
}
