import 'dart:ui';

import 'package:flash_chat/components/buttons.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  static const String page_id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  var phoneNumber;
  String smsCode;
  String verificationId;
  final FirebaseAuth _iAuth = FirebaseAuth.instance;

  Future<void> fVerifyPhone(dynamic phoneNumber) async {
    try {
      await _iAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _iAuth.signInWithCredential(credential);
          print('ok');
        },
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            print('phone number is not valid');
          } else {
            print('this: $e');
          }
          print('failed');
        },
        codeSent: (String verificationId, int resendToken) async {
          smsCode = await smsDialogBox();
          if (smsCode == null) {
            return;
          }
          PhoneAuthCredential phoneAuthCredential =
              PhoneAuthProvider.credential(
            verificationId: verificationId,
            smsCode: smsCode,
          );

          await _iAuth.signInWithCredential(phoneAuthCredential);
          Navigator.pushNamed(context, ChatScreen.page_id);
        },
        timeout: const Duration(seconds: 30),
        codeAutoRetrievalTimeout: (String verificationId) {
          print('timed out');
          print(verificationId);
        },
      );
    } catch (e) {
      print('this message from verifyPhoneNumber: $e');
    }
  }

  Future<String> smsDialogBox() {
    String code;
    String errorMsg = 'Please Enter Your Smscode ';
    String titleText = ' smscode ';
    bool error = false;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // backgroundColor: Colors.orangeAccent,
          title: Center(
            child: Text(
              titleText,
              style: TextStyle(color: Colors.blue[50], fontSize: 32),
            ),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  height: 250.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 48),
                        onChanged: (value) {
                          code = value;
                        },
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      (error
                          ? Text(
                              errorMsg,
                              style: TextStyle(color: Colors.red),
                            )
                          : Container()),
                      TextButton(
                        onPressed: () {
                          code == null || code == ''
                              ? setState(() {
                                  error = true;
                                })
                              : Navigator.of(context).pop(code);
                        },
                        child: Text(
                          'CONFIRM',
                          style: kCbuttonTextStyle,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'CANCEL',
                          style: kCbuttonTextStyle,
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
          contentPadding: EdgeInsets.only(left: 24, right: 24),
          actions: [],
        );
      },
    );
  }

  fShowSnackbar(String msg) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 80.0),
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
            TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.phone,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              style: TextStyle(color: Colors.black87),
              onChanged: (value) {
                phoneNumber = '+90$value';
                //Do something with the user input.
              },
              decoration: kTextFileDecoration.copyWith(
                  hintText: 'Enter Your Phone Number'),
            ),
            Cbutton(
              vColor: Colors.blueAccent,
              vText: 'Send Me Code',
              fPressed: () {
                fVerifyPhone(phoneNumber);
              },
            ),
            Cbutton(
              vColor: Colors.blueAccent,
              vText: 'auth check',
              fPressed: () {
                _iAuth.authStateChanges().listen((User user) {
                  if (user == null) {
                    fShowSnackbar('signed out');
                  } else {
                    fShowSnackbar(user.uid);
                  }
                });
              },
            ),
            Cbutton(
              vColor: Colors.blueAccent,
              vText: 'sign out',
              fPressed: () async {
                if (_iAuth.currentUser == null) {
                  fShowSnackbar('already signed out');
                } else {
                  await _iAuth.signOut();
                  fShowSnackbar('signed out');
                }
              },
            ),
            BackButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
