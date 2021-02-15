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
  FirebaseAuth _iAuth = FirebaseAuth.instance;
  dynamic _cancelListener;

  Future<void> verifyPhone(dynamic phoneNumber) async {
    await _iAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _iAuth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('phone number is not valid');
        } else {
          print('this: $e');
        }
      },
      codeSent: (String verificationId, int resendToken) async {
        smsCode = await smsDialogBox(context);
        if (smsCode == null) {
          showSnackbar('there is no smscode');
        }
        PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
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
  }

  Future<String> smsDialogBox(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Enter Sms Code',
          ),
          content: Container(
            height: 100.0,
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    smsCode = value;
                  },
                ),
              ],
            ),
          ),
          contentPadding: EdgeInsets.only(left: 32, right: 32),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop(smsCode);
                },
                child: Text('OK'),
              ),
            )
          ],
        );
      },
    );
  }

  showSnackbar(String msg) {
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
        padding: EdgeInsets.symmetric(horizontal: 24.0),
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
                verifyPhone(phoneNumber);
              },
            ),
            Cbutton(
              vColor: Colors.blueAccent,
              vText: 'auth check',
              fPressed: () {
                _cancelListener = _iAuth.authStateChanges().listen((User user) {
                  if (user == null) {
                    showSnackbar('signed out');
                  } else {
                    showSnackbar(user.uid);
                  }
                });
              },
            ),
            Cbutton(
              vColor: Colors.blueAccent,
              vText: 'sign out',
              fPressed: () async {
                showSnackbar('signed out');
                _cancelListener();
                await _iAuth.signOut();
              },
            ),
          ],
        ),
      ),
    );
  }
}
