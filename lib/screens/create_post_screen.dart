import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/models/post_model.dart';
import 'package:insta_clone/models/user_data.dart';
import 'package:insta_clone/services/database_service.dart';
import 'package:insta_clone/services/storage_service.dart';
import 'package:provider/provider.dart';

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
      imageFile=await _cropImage(imageFile);
      setState(() {
        _image=imageFile;
      });
    }
  }

  _cropImage(File imageFile) async{
    File croppedImage=await ImageCropper.cropImage(sourcePath: imageFile.path,aspectRatio: CropAspectRatio(ratioX: 1.0,ratioY: 1.0));
    return croppedImage;
  }

  _submit() async{
    if(!isLoading && _image!=null && _caption.isNotEmpty){
      setState(() {
        isLoading=true;
      });

      //create post
      String imageUrl=await StorageService.uploadPost(_image);
      Post post=Post(
        imageUrl: imageUrl,
        caption: _caption,
        likes: 0,
        authorId: Provider.of<UserData>(context,listen: false).currentUserId,
        timestamp: Timestamp.fromDate(DateTime.now())
      );

      DatabaseService.createPost(post);

      //reset
      _captionController.clear();

      setState(() {
        _caption='';
        _image=null;
        isLoading=false;
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
            onPressed: _submit,
          )
        ],
      ),
      body: GestureDetector(
        onTap: ()=>FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            height: height,
            child: Column(
              children: <Widget>[
                isLoading ? Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.blue[200],
                    valueColor: AlwaysStoppedAnimation(
                      Colors.blue
                    ),
                  ),
                ):SizedBox.shrink(),
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
                ),
                SizedBox(height: 20.0,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:30.0),
                  child: TextField(
                    controller: _captionController,
                    style: TextStyle(
                      fontSize: 18.0
                    ),
                    decoration: InputDecoration(
                      labelText: "Caption"
                    ),
                    onChanged: (input)=>_caption=input,
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}
