import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/models/user_model.dart';
import 'package:insta_clone/services/database_service.dart';
import 'package:insta_clone/services/storage_service.dart';

class EditProfileScreen extends StatefulWidget {

  final User user;

  EditProfileScreen({this.user});


  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {

  final _formKey=GlobalKey<FormState>();
   String _name='';
   String _bio='';

   File _profileImage;


  @override
  void initState() {
    super.initState();
    _name=widget.user.name;
    _bio=widget.user.bio;
  }

  _handleImageFromGallery() async{
    File imageFile=await ImagePicker.pickImage(source: ImageSource.gallery);
    if(imageFile!=null){
      setState(() {
        _profileImage=imageFile;
      });
    }
  }

  _displayProfileImage(){
    //no new pic
    if(_profileImage==null){
      if(widget.user.profileImageUrl.isEmpty){
        return AssetImage('assets/images/user-placeholder.jpg');
      }
      else{
        return CachedNetworkImageProvider(widget.user.profileImageUrl);
      }
    }
    else{
      //new pic
      return FileImage(_profileImage);
    }
  }

  _submitForm() async{
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();

      String _profileImageUrl='';

      if(_profileImage==null){
        _profileImageUrl=widget.user.profileImageUrl;
      }
      else{
        _profileImageUrl=await StorageService.uploadUserProfileImage(widget.user.profileImageUrl, _profileImage);
      }


      User user=User(
          id: widget.user.id,
          name: _name,
          bio: _bio,
          profileImageUrl: _profileImageUrl
      );

      //DB Update
      DatabaseService.updateUser(user);

      Navigator.pop(context);


    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.black
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 60.0,
                    backgroundColor: Colors.grey,
                    backgroundImage:_displayProfileImage()
                  ),
                  FlatButton(
                    onPressed: _handleImageFromGallery,
                    child: Text(
                      "Change Profile Image",
                      style: TextStyle(
                        color: Theme.of(context).accentColor
                      ),
                    ),
                  ),
                  TextFormField(
                    initialValue: _name,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                    decoration: InputDecoration(
                      icon: Icon(Icons.person,size: 30.0,),
                      labelText: 'Name'
                    ),
                    validator: (input)=>input.isEmpty ? 'Please Enter Name':null,
                    onSaved: (input)=>_name=input,
                  ),
                  TextFormField(
                    initialValue: _bio,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                    decoration: InputDecoration(
                        icon: Icon(Icons.book,size: 30.0,),
                        labelText: 'Bio'
                    ),
                    validator: (input)=>input.trim().length>150 ? 'Please Enter Bio less than 150 chars':null,
                    onSaved: (input)=>_bio=input,
                  ),
                  Container(
                    margin: EdgeInsets.all(40.0),
                    height: 40.0,
                    width: 250.0,
                    child: FlatButton(
                      onPressed: _submitForm,
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Text(
                        "Save Changes",
                        style: TextStyle(
                          fontSize: 16.0
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
