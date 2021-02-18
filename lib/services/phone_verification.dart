import 'package:flash_chat/components/sms_dialog_box.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyPhone {
  var phoneNumber;
  String smsCode;
  String verificationId;
  PhoneAuthCredential phoneAuthCredential;
  BuildContext contextFromScreen;
  static bool isInvalidNumber = false;
  static bool isTimeOut = false;

  VerifyPhone({this.phoneNumber, this.contextFromScreen});

  Future<void> verifyPhone() async {
    await mAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      //verificationCompleted not calling automatically?? -> is calling if device support it
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
        try {
          await mAuth.signInWithCredential(phoneAuthCredential).then((value) {
            userCredential = value;
            isInvalidNumber = false;
          });
        } catch (e) {
          return e;
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('phone number is not valid');
        } else {
          print('from verificationFailed: $e');
        }
        // only when verification failed that will be true, so that it will warning to user for an error
        isInvalidNumber = true;
        Navigator.pushNamed(contextFromScreen, RegistrationScreen.page_id);
      },
      codeSent: (String verificationId, [int resendToken]) async {
        smsCode =
            await SmsDialogBox(context: contextFromScreen).showSmsDialogBox();
        phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: smsCode,
        );
        try {
          await mAuth.signInWithCredential(phoneAuthCredential).then((value) {
            userCredential =
                value; // to global variable area for user credentials using in that area
            isInvalidNumber = false;
            isTimeOut = false;
          });
        } catch (e) {
          return e;
        }
      },
      timeout: const Duration(seconds: 30),
      //# when sms code is incorrect that code triggered don't isInvalidNumber false
      codeAutoRetrievalTimeout: (String verificationId) {
        print('timed out');
        if (vUser == null) {
          isInvalidNumber = false;
          isTimeOut = true;
          Navigator.pushNamed(contextFromScreen, RegistrationScreen.page_id);
        }
      },
    );
  }
}
