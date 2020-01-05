import 'package:flutter/material.dart';

class CreatePost extends StatefulWidget {
  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "Instagram",
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'Billabong',
              fontSize: 35.0
          ),
        ),
      ),
      body: Center(
        child: Text(
            "create"
        ),
      ),
    );
  }
}
