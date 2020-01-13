import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_clone/models/post_model.dart';
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

  static void createPost(Post post){
    postsRef.document(post.authorId).collection("userPosts").add({
      'imageUrl':post.imageUrl,
      'caption':post.caption,
      'likes':post.likes,
      'authorId':post.authorId,
      'timestamp':post.timestamp
    });
  }

  static void followUser(String currentUserId,String userId){
    //add user to current users following
    followingRef.document(currentUserId).collection("usersFollowing").document(userId).setData({});


    //add current user to users' followers
    followersRef.document(userId).collection("usersFollowers").document(currentUserId).setData({});
  }

  static void unFollowUser(String currentUserId,String userId){
    //remove user from current users following
    followingRef.document(currentUserId).collection("usersFollowing").document(userId).get().then((doc){
      if(doc.exists){
        doc.reference.delete();
      }
    });


    //remove current user from users' followers
    followersRef.document(userId).collection("usersFollowers").document(currentUserId).get().then((doc){
      if(doc.exists){
        doc.reference.delete();
      }
    });
  }

  static Future<bool> isFollowingUser({String currentUserId,String userId})async{
    DocumentSnapshot followingDoc=await followersRef.document(userId).collection("usersFollowers").document(currentUserId).get();
    return followingDoc.exists;
  }

  static Future<int> numFollowers(String userId) async{
    QuerySnapshot followerSnapshot=await followersRef.document(userId).collection("usersFollowers").getDocuments();
    return followerSnapshot.documents.length;
  }

  static Future<int> numFollowing(String userId) async{
    QuerySnapshot followingSnapshot=await followingRef.document(userId).collection("usersFollowing").getDocuments();
    return followingSnapshot.documents.length;
  }

  static Future<List<Post>> getFeedPosts(String userId)async{
    QuerySnapshot feedSnapshot=await feedRef.document(userId).collection('userFeed').orderBy('timestamp',descending: true).getDocuments();
    List<Post> posts=feedSnapshot.documents.map((doc)=>Post.fromDoc(doc)).toList();
    return posts;
  }

  static Future<User> getUserWithId(String userId) async{
    DocumentSnapshot userDocSnapshot= await usersRef.document(userId).get();
    if(userDocSnapshot.exists){
      return User.fromDoc(userDocSnapshot);
    }
    return User();
  }
}