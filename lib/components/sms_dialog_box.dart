import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/screens/registration_screen.dart';

class SmsDialogBox {
  BuildContext context;

  SmsDialogBox({this.context});

  Future<String> showSmsDialogBox() {
    String smsCode;
    int smsCodeLenght = 6;
    String errorMsg = 'Please Enter Your smscode ';
    String titleText = ' smsCode ';
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
                          smsCode = value;
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
                          smsCode == null ||
                                  smsCode == '' ||
                                  smsCode.length < smsCodeLenght
                              ? setState(() {
                                  error = true;
                                })
                              : Navigator.of(context).pop(smsCode);
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
                          Navigator.pushNamed(
                              context, RegistrationScreen.page_id);
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
