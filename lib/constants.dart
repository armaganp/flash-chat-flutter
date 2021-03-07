import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
  hintText: 'buraya yazin...',
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    top: BorderSide(color: Colors.amberAccent, width: 1.5),
    bottom: BorderSide(color: Colors.amberAccent, width: 1.5),
  ),
);

const kCbuttonTextStyle = TextStyle(
  fontSize: 24,
);
const kTextFileDecoration = InputDecoration(
  hintText: null,
  focusColor: Colors.black,
  hintStyle: TextStyle(color: Colors.black12),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(16.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 3.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);
