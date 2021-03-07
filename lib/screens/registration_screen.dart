import 'dart:developer';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/components/buttons.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/globals.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegistrationScreen extends StatefulWidget {
  static const String page_id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  TextEditingController textEditingControllerUsername = TextEditingController();
  TextEditingController textEditingControllerPhone = TextEditingController();
  var phoneNumber;
  var nickName;
  String smsCode;

  bool showSpinner = false;

  bool isInvalidNumber = false;
  bool isSmsWrong = false; // time out
  bool isCancel = false;
  bool userIsRegistered;

  String snackBarMsg;
  void saveUser(var phoneNum, var id) async {
    log('saveUser(): saving..');
    db.collection("Users").doc(nickName).set({
      "uid": id,
      "phoneNumber": phoneNum,
    }).then((_) {
      log('saveUser(): user saved');
    });
  }

  //nickname and phone number must  be not already taken if so we have to cancel saving process
  //[BUG]maybe user is saved before this function complete
  // 3/6/2021 yep its working right now
  Future<bool> controlUser() async {
    setState(() {
      showSpinner = true;
    });
    Map<String, dynamic> mapData;
    QuerySnapshot messages = await db.collection('Users').get();
    for (var doc in messages.docs) {
      mapData = doc.data();
      String phone = '${mapData['phoneNumber']}';
      log('${doc.id} $phone');
      if (nickName == doc.id || phoneNumber == phone) {
        log('already taken nick or phone number');
        return false;
      }
    }
    return true;
  }

  exitVerifyPhone() {
    setState(() {
      showSpinner = false;
    });
  }

  Future<void> verifyPhone() async {
    await mAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
        try {
          await mAuth.signInWithCredential(phoneAuthCredential).then((value) {
            gUserCredential = value;
            if (value.additionalUserInfo.isNewUser) {
              // new user
              // phone verify ok we must be save new  userId to db
              log('new user signed : $gUserCredential');
              saveUser(value.user.phoneNumber, value.user.uid);
            }
          });
        } catch (e) {
          return e;
        }
        exitVerifyPhone();
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          log('phone number is not valid');
          isInvalidNumber = true; //*
          isSmsWrong = false;
          isCancel = false;
        } else {
          log('from verificationFailed: $e'); // debug purpose only
          log('verification failed due to unknown status'); // implement unknown status maybe later
        }
        exitVerifyPhone();
      },
      codeSent: (String verificationId, [int resendToken]) async {
        smsCode = await showSmsDialogBox();
        if (smsCode == null) {
          isCancel = true; // *
          isInvalidNumber = false;
          isSmsWrong = false;
          log('process canceled form user');
          exitVerifyPhone();
        }

        PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: smsCode,
        );

        try {
          await mAuth.signInWithCredential(phoneAuthCredential).then((value) {
            gUserCredential = value;
            if (value.additionalUserInfo.isNewUser) {
              // new user
              // phone verify ok we must be save new  userId to db
              log('new user signed : $gUserCredential');
              saveUser(value.user.phoneNumber, value.user.uid);
            }
          });
        } catch (e) {
          return e;
        }
        exitVerifyPhone();
      },
      timeout: const Duration(seconds: 10),
      //# when sms code is incorrect that code triggered
      codeAutoRetrievalTimeout: (String verificationId) async {
        log('timed out');
        if (vUser == null && smsCode != null) {
          // don't remove user in 10 seconds otherwise it showing wrong sms warning due to null user
          isSmsWrong = true; // *
          isCancel = false;
          isInvalidNumber = false;
          exitVerifyPhone();
        }
      },
    );
  }

  fShowSnackBar(String snackBarMsg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(snackBarMsg),
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
    // later implemet it
    // if (isInvalidNumber || isSmsWrong || isCancel) {
    //   textEditingControllerPhone.clear();
    //   textEditingControllerUsername.clear();
    // }
    String wrongNumber = 'invalid number ';
    String wrongSmsCode = 'invalid sms code ';
    String cancel = 'canceled';
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
              (isInvalidNumber
                  ? Center(
                      child: Text(
                        'verification failed: $wrongNumber',
                        style: TextStyle(color: Colors.red, fontSize: 16.0),
                      ),
                    )
                  : Container()),
              (isSmsWrong
                  ? Center(
                      child: Text(
                        'verification failed: $wrongSmsCode',
                        style: TextStyle(color: Colors.red, fontSize: 16.0),
                      ),
                    )
                  : Container()),
              (isCancel
                  ? Center(
                      child: Text(
                        'verification failed: $cancel',
                        style: TextStyle(color: Colors.green, fontSize: 16.0),
                      ),
                    )
                  : Container()),
              // text files must be clear after  an error edit -> 3/6/2021 add error code for already taken phone and username
              TextField(
                controller: textEditingControllerUsername,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.name,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.singleLineFormatter,
                ],
                style: TextStyle(color: Colors.black87),
                onChanged: (value) {
                  nickName = value;
                },
                decoration: kTextFileDecoration.copyWith(
                    hintText: 'Enter Your Nickname'),
              ),
              SizedBox(
                height: 8,
              ),
              TextField(
                controller: textEditingControllerPhone,
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
                fPressed: () async {
                  if (phoneNumber != null && nickName != null) {
                    userIsRegistered = await controlUser();
                    if (userIsRegistered) {
                      await verifyPhone();
                    } else {
                      log('already registered user');
                      exitVerifyPhone();
                      // exitVerifyPhone();
                    }
                  } else {
                    fShowSnackBar('enter your number or nickname');
                  }
                },
              ),
              Cbutton(
                // AUTH CHECK {FOR DEBUG}
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
              // this button ? - is corrected
              BackButton(
                onPressed: () {
                  Navigator.pushNamed(context, ChatScreen.page_id);
                },
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> showSmsDialogBox() {
    String sCode;
    int smsCodeLenght = 6;
    String errorMsg = 'Please Enter Your smscode ';
    String titleText = '  Verification Code ';
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
                padding: const EdgeInsets.all(8),
                child: Container(
                  height: 250.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                        maxLength: smsCodeLenght,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 48),
                        onChanged: (value) {
                          sCode = value;
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
                          sCode == null ||
                                  sCode == '' ||
                                  sCode.length < smsCodeLenght
                              ? setState(() {
                                  error = true;
                                })
                              : Navigator.of(context).pop(sCode);
                        },
                        child: Text(
                          'CONFIRM',
                          style: kCbuttonTextStyle,
                        ),
                      ),
                      // there is a problem screen  giving a wrong sms error maybe route welcome screen
                      // -> is corrected with (vUser = user) and control it
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
}
