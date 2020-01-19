import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/models/post_model.dart';
import 'package:insta_clone/models/user_data.dart';
import 'package:insta_clone/models/user_model.dart';
import 'package:insta_clone/screens/edit_profile_screen.dart';
import 'package:insta_clone/services/database_service.dart';
import 'package:insta_clone/utilities/constants.dart';
import 'package:insta_clone/widgets/post_view.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {

  final String userID;
  final String currentUserId;

  ProfileScreen({this.currentUserId,this.userID});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  bool _isFollowing=false;
  int _followersCount=0;
  int _followingCount=0;
  List<Post> _posts=[];
  int _displayPosts=0; //0-grid 1-col

  User _profileUser;



  @override
  void initState() {
    super.initState();
    _setupIsFollowing();
    _setupFollowers();
    _setupFollowing();
    _setupPosts();
    _setupProfileUser();
  }

  _setupProfileUser()async{
    User profileUser=await DatabaseService.getUserWithId(widget.userID);
    setState(() {
      _profileUser=profileUser;
    });
    
  }

  _setupPosts() async{
    List<Post> posts=await DatabaseService.getUserPosts(widget.userID);
    setState(() {
      _posts=posts;
    });
  }

  _setupIsFollowing()async{
    bool isFollowingUser=await DatabaseService.isFollowingUser(
      currentUserId: widget.currentUserId,
      userId:widget.userID
    );
    setState(() {
      _isFollowing=isFollowingUser;
    });
  }

  _setupFollowers() async{
    int user_followersCount=await DatabaseService.numFollowers(widget.userID);
    setState(() {
      _followersCount=user_followersCount;
    });

  }

  _setupFollowing()async{
    int user_followingCount=await DatabaseService.numFollowing(widget.userID);
    setState(() {
      _followingCount=user_followingCount;
    });
  }

  _followorUnfollow(){
    if(_isFollowing){
      _unFollowUser();
    }
    else{
      _followUser();
    }
  }

  _unFollowUser(){
    DatabaseService.unFollowUser(widget.currentUserId,widget.userID);
    setState(() {
      _isFollowing=false;
      _followersCount--;
    });
  }

  _followUser(){
    DatabaseService.followUser(widget.currentUserId, widget.userID);
    setState(() {
      _isFollowing=true;
      _followersCount++;
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
        color: _isFollowing?Colors.grey[200]:Colors.blue,
        textColor: _isFollowing?Colors.black:Colors.white,
        child: Text(
          _isFollowing?"Unfollow":"Follow",
          style: TextStyle(
              fontSize: 16.0
          ),
        ),
      ),
    );
  }

  _buildTilePost(Post post){
    return GridTile(
      child: Image(
        image: CachedNetworkImageProvider(post.imageUrl),
        fit: BoxFit.cover,
      ),
    );
  }

  _buildDisplayPost() {
    if(_displayPosts==0){
      List<GridTile> tiles=[];
      _posts.forEach((post){
        tiles.add(_buildTilePost(post));
      });
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        shrinkWrap: true,
        children: tiles,
        physics: NeverScrollableScrollPhysics(),
      );
    }
    else{
      List<PostView> postViews=[];
      _posts.forEach((post) {
        postViews.add(PostView(currentUserId: widget.currentUserId,post: post,author:_profileUser,));
      });
      return Column(
        children:postViews
      );
    }
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
                                    _posts.length.toString(),
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
                                    _followersCount.toString(),
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
                                    _followingCount.toString(),
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
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.grid_on),
                    iconSize: 30.0,
                    color: _displayPosts==0?Theme.of(context).primaryColor:Colors.grey[300],
                    onPressed: ()=> setState((){
                      _displayPosts=0;
                    }),
                  ),
                  IconButton(
                    icon: Icon(Icons.list),
                    iconSize: 30.0,
                    color: _displayPosts==1?Theme.of(context).primaryColor:Colors.grey[300],
                    onPressed: ()=> setState((){
                      _displayPosts=1;
                    }),
                  )
                ],
              ),
              _buildDisplayPost()
            ],
          );
        }
      )
    );
  }
}
