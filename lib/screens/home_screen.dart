import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/screens/activity_screen.dart';
import 'package:insta_clone/screens/create_post_screen.dart';
import 'package:insta_clone/screens/feed_screen.dart';
import 'package:insta_clone/screens/profile_screen.dart';
import 'package:insta_clone/screens/search_screen.dart';

class HomeScreen extends StatefulWidget {

   static final String id='home_screen';
   final String userID;

   HomeScreen({this.userID});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _currentTab=0;
  PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController=PageController();
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
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          FeedScreen(),
          SearchScreen(),
          CreatePost(),
          ActivityScreen(),
          ProfileScreen(userID: widget.userID,)
        ],
        onPageChanged: (int index){
          setState(() {
            _currentTab=index;
          });
        },
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Colors.white,
        activeColor: Colors.black,
        currentIndex: _currentTab,
        onTap: (int index){
          setState(() {
            _currentTab=index;
          });
          _pageController.animateToPage(index, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 32.0,
            )
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: 32.0,
              )
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.photo_camera,
                size: 32.0,
              )
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.notifications,
                size: 32.0,
              )
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle,
                size: 32.0,
              )
          )
        ],
      ),
    );
  }
}
