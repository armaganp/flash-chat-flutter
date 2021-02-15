import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';

class Cbutton extends StatelessWidget {
  final Color vColor;
  final Function fPressed;
  final String vText;
  Cbutton({
    this.vColor = Colors.blueAccent,
    @required this.fPressed,
    @required this.vText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: vColor,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: fPressed,
          minWidth: 200.0,
          height: 50.0,
          textColor: Colors.white70,
          child: Text(
            vText,
            style: kCbuttonTextStyle,
          ),
        ),
      ),
    );
  }
}
