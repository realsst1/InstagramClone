import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:insta_clone/models/user_data.dart';
import 'package:insta_clone/screens/feed_screen.dart';
import 'package:insta_clone/screens/home_screen.dart';
import 'package:insta_clone/screens/login_screen.dart';
import 'package:provider/provider.dart';

class AuthService{
  static final _auth=FirebaseAuth.instance;
  static final _firestore=Firestore.instance;

  static void signUpUser (BuildContext context,String name,String email,String password) async{
    try{
      AuthResult authResult=await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser signedInUser=authResult.user;
      if(signedInUser!=null){
        _firestore.collection("/users").document(signedInUser.uid).setData({
          'name':name,
          'email':email,
          'profileImageUrl':''
        });

        Provider.of<UserData>(context).currentUserId=signedInUser.uid;
        print("Signed in:"+signedInUser.uid);
        //Navigator.pushReplacementNamed(context,FeedScreen.id);
        Navigator.pop(context);
      }
    }
    catch(e){
      print(e);
    }
  }

  static void logout(){
    _auth.signOut();
  }

  static void login(String email,String password)async{
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      // TODO
      print(e);
    }
  }
}