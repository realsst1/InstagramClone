import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {

  File _image;
  TextEditingController _captionController=TextEditingController();
  String _caption='';
  bool isLoading=false;

  _showSelectImageDialog(){
    return Platform.isIOS ? _iosBottomSheet() : _androidDialog();
  }

  _iosBottomSheet(){
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context){
          return CupertinoActionSheet(
            title: Text("Add Photo"),
            actions: <Widget>[
              CupertinoActionSheetAction(
                child: Text("Take Photo"),
                onPressed: ()=>_handleImageSource(ImageSource.camera),
              ),
              CupertinoActionSheetAction(
                child: Text("Choose Photo from Gallery"),
                onPressed: ()=>_handleImageSource(ImageSource.gallery),
              )
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text("Cancel"),
              onPressed: ()=>Navigator.pop(context),
            ),
          );
        }
    );

  }

  _androidDialog(){
    showDialog(
      context: context,
      builder: (BuildContext context){
          return SimpleDialog(
            title: Text("Add a photo"),
            children: <Widget>[
              SimpleDialogOption(
                child: Text("Take a photo"),
                onPressed: ()=>_handleImageSource(ImageSource.camera),
              ),
              SimpleDialogOption(
                child: Text("Choose from gallery"),
                onPressed: ()=>_handleImageSource(ImageSource.gallery),
              ),
              SimpleDialogOption(
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.redAccent),
                ),
                onPressed: ()=>Navigator.pop(context),
              )
            ],
          );
      }
    );
  }


  _handleImageSource(ImageSource source) async{
    Navigator.pop(context);
    File imageFile=await ImagePicker.pickImage(source: source);
    if(imageFile!=null){
      setState(() {
        _image=imageFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width=MediaQuery.of(context).size.width;
    final height=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "Create Post",
          style: TextStyle(
              color: Colors.black
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: ()=>print("add"),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          GestureDetector(
            onTap: _showSelectImageDialog,
            child: Container(
              height: width,
              width: width,
              color: Colors.grey[300],
              child:_image==null ? Icon(
                Icons.add_a_photo,
                color: Colors.white70,
                size: 150.0,
              ):Image(image: FileImage(_image),fit: BoxFit.cover,) ,
            ),
          )
        ],
      )
    );
  }
}
