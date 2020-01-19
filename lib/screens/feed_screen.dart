import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/models/post_model.dart';
import 'package:insta_clone/models/user_data.dart';
import 'package:insta_clone/models/user_model.dart';
import 'package:insta_clone/screens/profile_screen.dart';
import 'package:insta_clone/services/auth_service.dart';
import 'package:insta_clone/services/database_service.dart';
import 'package:insta_clone/widgets/post_view.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {

  static final String id='feed_screen';
  final String currentUserId;

  FeedScreen({this.currentUserId});

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {

  List<Post> _posts=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setupFeed();
  }

  _setupFeed()async{

    List<Post> posts=await DatabaseService.getFeedPosts(widget.currentUserId);
    setState(() {
      _posts=posts;
    });
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
      body:_posts.length>0 ? RefreshIndicator(
        onRefresh: ()=>_setupFeed(),
        child: ListView.builder(
          itemCount: _posts.length,
          itemBuilder: (BuildContext context,int index){
            Post post=_posts[index];
            return FutureBuilder(
              future: DatabaseService.getUserWithId(post.authorId),
              builder: (BuildContext context,AsyncSnapshot snapshot){
                if(!snapshot.hasData){
                  return SizedBox.shrink();
                }
                User author=snapshot.data;
                return PostView(currentUserId: widget.currentUserId,post:post,author: author);
              },
            );
          },
        ),
      ):Center(child: CircularProgressIndicator(),)
    );
  }
}
