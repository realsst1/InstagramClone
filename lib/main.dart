import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/models/user_data.dart';
import 'package:insta_clone/screens/feed_screen.dart';
import 'package:insta_clone/screens/home_screen.dart';
import 'package:insta_clone/screens/login_screen.dart';
import 'package:insta_clone/screens/sign_up.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  Widget _getScreenId(){
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context,snapshot){
        if(snapshot.hasData){
          Provider.of<UserData>(context).currentUserId=snapshot.data.uid;
          return HomeScreen();
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
    return ChangeNotifierProvider(
      child: MaterialApp(
        title: 'Instagram Clone',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryIconTheme: Theme.of(context).primaryIconTheme.copyWith(color: Colors.black)
        ),
        home: _getScreenId(),
        routes: {
          LoginScreen.id:(context)=>LoginScreen(),
          SignupScreen.id:(context)=>SignupScreen(),
          FeedScreen.id:(context)=>FeedScreen(),
          HomeScreen.id:(context)=>HomeScreen()
        },
      ),
      create:(context)=>UserData()
    );
  }
}

