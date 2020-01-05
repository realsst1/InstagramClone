import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_clone/models/user_model.dart';
import 'package:insta_clone/utilities/constants.dart';

class DatabaseService{
  static void updateUser(User user){
    usersRef.document(user.id).updateData({
      'name':user.name,
      'bio':user.bio,
      'profileImageUrl':user.profileImageUrl
    });
  }

  static Future<QuerySnapshot> searchUsers(String name){
    Future<QuerySnapshot> users=usersRef.where('name',isGreaterThanOrEqualTo: name).getDocuments();
    return users;

  }
}