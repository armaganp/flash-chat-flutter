import 'dart:ui';

import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/components/buttons.dart';

class LoginScreen extends StatefulWidget {
  static const String page_id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              //username
              onChanged: (value) {
                //Do something with the user input.
              },
              decoration: kTextFileDecoration.copyWith(
                hintText: 'Enter Your Email',
              ),
              style: TextStyle(color: Colors.black87),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              //password
              obscureText: true,
              onChanged: (value) {
                //Do something with the user input.
              },
              decoration: kTextFileDecoration.copyWith(
                hintText: 'Enter Your Password',
              ),
              style: TextStyle(
                color: Colors.black87,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Cbutton(
              vColor: Colors.lightBlueAccent,
              vText: 'Log In',
              fPressed: () {
                Navigator.pushNamed(context, ChatScreen.page_id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
