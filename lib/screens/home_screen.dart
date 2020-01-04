import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {

   static final String id='home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _currentTab=0;

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
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Colors.white,
        currentIndex: _currentTab,
        onTap: (int index){
          setState(() {
            _currentTab=index;
          });
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
