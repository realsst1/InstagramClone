import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/models/user_model.dart';
import 'package:insta_clone/screens/profile_screen.dart';
import 'package:insta_clone/services/database_service.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController _searchController=TextEditingController();
  Future<QuerySnapshot> _users;

  _buildUserTile(User user){
    return ListTile(
      leading: CircleAvatar(
        radius: 20.0,
        backgroundImage: user.profileImageUrl.isEmpty?
        AssetImage('assets/images/user-placeholder.jpg'):
        CachedNetworkImageProvider(user.profileImageUrl),
      ),
      title: Text(
        user.name
      ),
      onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>ProfileScreen(userID: user.id,))),
    );
  }

  _clearSearch(){
    WidgetsBinding.instance.addPostFrameCallback((_)=>_searchController.clear());
    setState(() {
      _users=null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 15.0),
            border: InputBorder.none,
            hintText: "Search",
            prefixIcon: Icon(Icons.search,size: 30.0,),
            suffixIcon: IconButton(icon:Icon(Icons.clear),onPressed:_clearSearch,),
            filled: true
          ),
          onSubmitted: (input){
            if(input.isNotEmpty){
              setState(() {
                _users=DatabaseService.searchUsers(input);
              });
            }
          },
        )
      ),
      body: _users==null?
        Center(child: Text("Search for a user"),):FutureBuilder(
        future: _users,
        builder: (context,snapshots){
          if(!snapshots.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if(snapshots.data.documents.length==0){
            return Center(
              child: Text(
                "No Users found! Please try again"
              ),
            );
          }
          return ListView.builder(
              itemCount: snapshots.data.documents.length,
              itemBuilder: (BuildContext context,int index){
                User user=User.fromDoc(snapshots.data.documents[index]);
                return _buildUserTile(user);
              }
          );
        },
      )
    );
  }
}
