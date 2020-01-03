import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {

  static final String id='signup_screen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final _formKey=GlobalKey<FormState>();
  String _email,_password,_name;

  _submit(){
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();

      print(_email);
      print(_password);

      //login

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Instagram",
              style: TextStyle(
                  fontSize: 50.0,
                  fontFamily: 'Billabong'
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:30.0,vertical: 10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Name',
                      ),
                      validator: (input)=>input.isEmpty?'Please enter valid name':null,
                      onSaved: (input)=>_name=input,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:30.0,vertical: 10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                      ),
                      validator: (input)=>!input.contains('@')?'Please enter valid email':null,
                      onSaved: (input)=>_email=input,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:30.0,vertical: 10.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                      validator: (input)=>input.length<6?'Password must be atleast 6 characters':null,
                      onSaved: (input)=>_password=input,
                      obscureText: true,
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Container(
                    width: 300.0,
                    child: FlatButton(
                      onPressed: _submit,
                      padding: EdgeInsets.all(14.0),
                      color: Colors.blue,
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Container(
                    width: 300.0,
                    child: FlatButton(
                      onPressed: ()=>Navigator.pop(context),
                      padding: EdgeInsets.all(14.0),
                      color: Colors.blue,
                      child: Text(
                        'Already Registered? Sign In',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
