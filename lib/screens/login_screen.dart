import 'package:flutter/material.dart';
import 'package:insta_clone/screens/sign_up.dart';
import 'package:insta_clone/services/auth_service.dart';


class LoginScreen extends StatefulWidget {

  static final String id='login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey=GlobalKey<FormState>();
  String _email,_password;

  _submit(){
    if(_formKey.currentState.validate()){
      _formKey.currentState.save();

      print(_email);
      print(_password);

      //login
      AuthService.login( _email, _password);  //context originaly not there

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
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
                          'Login',
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
                        onPressed: ()=>Navigator.pushNamed(context, SignupScreen.id),
                        padding: EdgeInsets.all(14.0),
                        color: Colors.blue,
                        child: Text(
                          'Not Registered? Signup',
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
      ),
    );
  }
}
