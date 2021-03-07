import 'dart:async';
import 'dart:developer';
import 'package:intl/intl.dart';

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
  String textMessage;
  int textNum = 0;
  List<Widget> card = [];

  ScrollController _controller = ScrollController();

  initState() {
    super.initState();
    realtimeReadText();
  }

  Future<String> getNick() async {
    QuerySnapshot user;
    String uid;

    user = await db.collection('Users').get();
    for (var doc in user.docs) {
      uid = doc.data()['uid'];
      if (uid == vUser.uid) {
        return doc.id;
      }
    }
    // if we reach here that mean is user not found
    return null;
  }

  Future<void> realtimeReadText() async {
    Stream<QuerySnapshot> queryStream = db.collection('Messages').snapshots();
    QuerySnapshot lastMessage;
    QueryDocumentSnapshot doc;
    CrossAxisAlignment side;
    Timestamp timestamp;
    DateTime dateTime;
    String time;
    String whoAmI;
    String sender;
    String message;

    queryStream.listen((snapshot) async {
      log('new snapshot');
      lastMessage = await db
          .collection('Messages')
          .orderBy('time', descending: true)
          .limit(1)
          .get();
      doc = lastMessage.docs[0];

      log('sender: ${doc.data()['sender']}');
      log('msg: ${doc.data()['msg']}');

      whoAmI = await getNick();
      timestamp = doc.data()['time'] as Timestamp;
      dateTime = timestamp.toDate();
      time = DateFormat.Hm().format(dateTime);
      if (doc.data() != null) {
        setState(() {
          sender = doc.data()['sender'];
          message = doc.data()['msg'];
          if (doc.id == whoAmI) {
            side = CrossAxisAlignment.start;
          } else {
            side = CrossAxisAlignment.end;
          }
        });
        card.insert(
          0,
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
            child: Column(
              crossAxisAlignment: side,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 0.6 * MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white12,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              sender,
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 11,
                              ),
                            ),
                            Text(
                              message,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        // padding: const EdgeInsets.only(left: 220),
                        padding: const EdgeInsets.fromLTRB(180, 0, 8, 8),
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              time,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.white54,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });
  }

  void saveText(var text) async {
    var nickName = await getNick();
    var timeStamp = DateTime.now();

    db.collection('Messages').doc(nickName).set({
      'msg': text,
      'time': timeStamp,
      'sender': nickName
      // 'time': FieldValue.serverTimestamp(),
    }, SetOptions(merge: false)).then((_) {
      log('saved');
    });
  }

  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    textEditingController.clear();
    return Scaffold(
      appBar: AppBar(
        // leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () async {
                await mAuth.signOut(); // this notify auth state listener
              }),
        ],
        title: Text('⚡️Anibal Pano'),
        backgroundColor: Colors.blueGrey,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: TextField(
                      controller: textEditingController,
                      onChanged: (value) {
                        textMessage = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  Expanded(
                    child: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        if (textEditingController.text.trim().isNotEmpty) {
                          saveText(textMessage);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: card,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
