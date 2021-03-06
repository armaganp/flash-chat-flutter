import 'dart:developer';

import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';

import 'package:flash_chat/components/buttons.dart';

import 'package:flash_chat/globals.dart';

class WelcomeScreen extends StatefulWidget {
  static const String page_id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
      upperBound: 100.0,
    );
    controller.forward();
    controller.addListener(() {
      setState(() {
        controller.value;
      });
    });
    bool isCurrentRoute = false;
    userStateListener = mAuth.authStateChanges().listen((User user) {
      if (user == null) {
        log('ws: user not registered');
        // if current screen not Welcome screen return to it
        Navigator.popUntil(
          context,
          (route) {
            if (route.settings.name == ChatScreen.page_id) {
              isCurrentRoute = true;
              log('ws: user unsigned  ');
            }
            return true;
          },
        );
        if (isCurrentRoute) {
          Navigator.pushNamed(context, WelcomeScreen.page_id);
        }
      } else {
        vUser = user; // user to global area
        log(vUser.phoneNumber);
        log('ws: already registered user');
        if (gUserCredential != null)
          log(' ws: new user: $gUserCredential'); // log credentials when user is new
        log('ws: ${user.uid}');
        Navigator.pushNamed(context, ChatScreen.page_id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height: controller.value,
                    ),
                  ),
                  TypewriterAnimatedTextKit(
                    text: ['Anibal Chat'],
                    speed: Duration(milliseconds: 150),
                    textStyle: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.black45),
                  ),
                ],
              ),
              SizedBox(
                height: 32.0,
              ),
              Cbutton(
                vColor: Colors.blueAccent,
                vText: 'Register',
                fPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.page_id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
