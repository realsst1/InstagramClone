import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/models/user_data.dart';
import 'package:insta_clone/models/user_model.dart';
import 'package:insta_clone/screens/edit_profile_screen.dart';
import 'package:insta_clone/services/database_service.dart';
import 'package:insta_clone/utilities/constants.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {

  final String userID;
  final String currentUserId;

  ProfileScreen({this.currentUserId,this.userID});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  bool isFollowing=false;
  int followersCount=0;
  int followingCount=0;


  @override
  void initState() {
    super.initState();
    _setupIsFollowing();
    _setupFollowers();
    _setupFollowing();
  }

  _setupIsFollowing()async{
    bool isFollowingUser=await DatabaseService.isFollowingUser(
      currentUserId: widget.currentUserId,
      userId:widget.userID
    );
    setState(() {
      isFollowing=isFollowingUser;
    });
  }

  _setupFollowers() async{
    int userFollowersCount=await DatabaseService.numFollowers(widget.userID);
    setState(() {
      followersCount=userFollowersCount;
    });

  }

  _setupFollowing()async{
    int userFollowingCount=await DatabaseService.numFollowing(widget.userID);
    setState(() {
      followingCount=userFollowingCount;
    });
  }

  _followorUnfollow(){
    if(isFollowing){
      _unFollowUser();
    }
    else{
      _followUser();
    }
  }

  _unFollowUser(){
    DatabaseService.unFollowUser(widget.currentUserId,widget.userID);
    setState(() {
      isFollowing=false;
      followersCount--;
    });
  }

  _followUser(){
    DatabaseService.followUser(widget.currentUserId, widget.userID);
    setState(() {
      isFollowing=true;
      followersCount++;
    });
  }

  _displayButton(User user){
    return user.id==Provider.of<UserData>(context).currentUserId?Container(
      width: 200.0,
      child: FlatButton(
        onPressed: ()=>Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_)=>EditProfileScreen(
              user: user,
            )
          )
        ),
        color: Colors.blue,
        textColor: Colors.white,
        child: Text(
          "Edit Profile",
          style: TextStyle(
              fontSize: 16.0
          ),
        ),
      ),
    ):
    Container(
      width: 200.0,
      child: FlatButton(
        onPressed: _followorUnfollow,
        color: isFollowing?Colors.grey[200]:Colors.blue,
        textColor: isFollowing?Colors.black:Colors.white,
        child: Text(
          isFollowing?"Unfollow":"Follow",
          style: TextStyle(
              fontSize: 16.0
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Instagram",
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Billabong',
                fontSize: 35.0
            ),
          ),
        ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: usersRef.document(widget.userID).get(),
        builder: (BuildContext context,AsyncSnapshot snapshot) {
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator());
          }
          User user=User.fromDoc(snapshot.data);
          return ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50.0,
                      backgroundColor: Colors.grey,
                      backgroundImage:
                          user.profileImageUrl.isEmpty?
                          AssetImage("assets/images/user-placeholder.jpg")
                              :CachedNetworkImageProvider(user.profileImageUrl)

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
                                    followersCount.toString(),
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
                                    followingCount.toString(),
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
                          _displayButton(user),
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
