import 'dart:async';
import 'dart:ui';

import 'package:flash_chat/components/buttons.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/globals.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/services/phone_verification.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const String page_id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  var phoneNumber;
  bool showSpinner = false;
  VerifyPhone vp;
  UserCredential vUserCredential;
  fShowSnackBar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        textColor: Colors.amber,
        label: 'message',
        onPressed: () {},
      ),
      backgroundColor: Colors.lightBlueAccent,
      behavior: SnackBarBehavior.fixed,
      duration: Duration(seconds: 1),
    ));
  }

  registerUser(var phoneNum) async {
    vp = VerifyPhone(phoneNumber: phoneNumber, contextFromScreen: context);
    setState(() {
      showSpinner = true;
    });
    await vp.verifyPhone();
  }

  @override
  Widget build(BuildContext context) {
    String wrongNumber = 'invalid number ';
    String wrongSmsCode = 'invalid sms code ';

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: Container(
                  height: 100.0,
                  child: Image.asset('images/logo.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              (VerifyPhone.isInvalidNumber
                  ? Center(
                      child: Text(
                        'verification failed: $wrongNumber',
                        style: TextStyle(color: Colors.red, fontSize: 16.0),
                      ),
                    )
                  : Container()),
              (VerifyPhone.isTimeOut
                  ? Center(
                      child: Text(
                        'verification failed: $wrongSmsCode',
                        style: TextStyle(color: Colors.red, fontSize: 16.0),
                      ),
                    )
                  : Container()),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.phone,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                style: TextStyle(color: Colors.black87),
                onChanged: (value) {
                  phoneNumber = '+90$value';
                },
                decoration: kTextFileDecoration.copyWith(
                    hintText: 'Enter Your Phone Number'),
              ),
              Cbutton(
                // SEND ME CODE
                vColor: Colors.blueAccent,
                vText: 'Send Me Code',
                fPressed: () {
                  (phoneNumber != null)
                      ? registerUser(phoneNumber)
                      : fShowSnackBar('enter a phone number');
                },
              ),
              Cbutton(
                vColor: Colors.blueAccent,
                vText: 'auth check',
                fPressed: () {
                  if (vUser == null) {
                    fShowSnackBar('signed out');
                  } else {
                    fShowSnackBar(mAuth.currentUser.uid);
                  }
                },
              ),
              // after verification failed navigates new register screen, spinner still running when press
              // this button ?
              BackButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
