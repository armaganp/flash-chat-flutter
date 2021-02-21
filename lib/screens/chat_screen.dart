import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:flash_chat/globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static const String page_id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var who = '';
  String textMessage;
  int textNum = 0;

  Future<String> getNick() async {
    var collectionUser;
    DocumentSnapshot userNickSnapshot;
    Map<String, dynamic> data;

    collectionUser = db.collection('Users');
    userNickSnapshot = await collectionUser.doc(vUser.uid).get();
    if (userNickSnapshot.exists) {
      data = userNickSnapshot.data();
    } else {
      log('getNick: something went wrong');
    }
    log('getNick: ${data['nick']}');
    return '${data['nick']}';
  }

  void realtimeReadText() {}

  void readText() async {
    var path = await getNick();
    var collectionMessages;
    DocumentSnapshot userTextSnapshot;
    Map<String, dynamic> data;

    collectionMessages = db.collection('Messages');
    userTextSnapshot = await collectionMessages.doc(path).get();
    if (userTextSnapshot.exists) {
      setState(() {
        data = userTextSnapshot.data();
        who = '${data['text']}';
        // String data = userTextSnapshot.get('text');
        // who = data;
      });
    }
  }

  void saveText(var text) async {
    var path = await getNick();
    log('saveText: $text');

    db.collection('Messages').doc(path).set({
      "text": text,
      "textNum": textNum++,
    }).then((_) {
      log('saveText: text saved');
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () async {
                await mAuth.signOut(); // this notify auth state listener
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              flex: 5,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      child: Text('show msg'),
                      onTap: () {
                        setState(() {
                          readText();
                        });
                      },
                    ),
                    Text(who),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: TextField(
                        onChanged: (value) {
                          //Do something with the user input.
                          textMessage = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          saveText(textMessage);
                          //Implement send functionality.
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            )
          ],
        ),
      ),
    );
  }
}
