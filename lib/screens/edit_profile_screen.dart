import 'package:flutter/material.dart';
import 'package:insta_clone/models/user_model.dart';

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



  _submitForm(){
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();

      String _profileImageUrl='';
      User user=User(
          id: widget.user.id,
          name: _name,
          bio: _bio,
          profileImageUrl: _profileImageUrl
      );

      //DB Update


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
                    backgroundImage: NetworkImage(
                        'http://p.imgci.com/db/PICTURES/CMS/289000/289002.1.jpg'
                    ),
                  ),
                  FlatButton(
                    onPressed: ()=>print('hhh'),
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
