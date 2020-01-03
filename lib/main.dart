import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/screens/feed_screen.dart';
import 'package:insta_clone/screens/login_screen.dart';
import 'package:insta_clone/screens/sign_up.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  Widget _getScreenId(){
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context,snapshot){
        if(snapshot.hasData){
          return FeedScreen();
        }
        else{
          return LoginScreen();
        }
      },

    );
  }


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _getScreenId(),
      routes: {
        LoginScreen.id:(context)=>LoginScreen(),
        SignupScreen.id:(context)=>SignupScreen(),
        FeedScreen.id:(context)=>FeedScreen()
      },
    );
  }
}

