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
}