import 'dart:async';

import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
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
  bool isCurrentRoute = false;
  void initState() {
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
    mAuth.authStateChanges().listen((User user) {
      if (user == null) {
        // vUser = user;
        print('welcome_screen: unsigned user');
        // if current screen not Welcome screen return it
        Navigator.popUntil(
          context,
          (route) {
            if (route.settings.name == ChatScreen.page_id) {
              isCurrentRoute = true;
              print('true');
            }
            return true;
          },
        );
        if (isCurrentRoute) {
          Navigator.pushNamed(context, WelcomeScreen.page_id);
        }
      } else {
        vUser = user;
        print('welcome_screen: ${user.uid}');
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
