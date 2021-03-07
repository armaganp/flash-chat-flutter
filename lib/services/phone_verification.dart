// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// Widget _buildBody(BuildContext context) {
//   Stream<QuerySnapshot> queryStream = db.collection('Messages').snapshots();
//   QuerySnapshot lastMessage;
//   QueryDocumentSnapshot doc;
//   return StreamBuilder<QuerySnapshot>(
//     stream: queryStream,
//     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//       queryStream.listen((snapshot) async {
//         lastMessage = await db
//             .collection('Messages')
//             .orderBy('time', descending: true)
//             .limit(1)
//             .get();
//         doc = lastMessage.docs[0];
//         log('sender: ${doc.data()['sender']}');
//         log('msg: ${doc.data()['msg']}');
//         if (doc.data() != null) {
//           card.add(Card(
//             color: Colors.amberAccent,
//             child: ListTile(
//               title: Text(doc.data()['sender']),
//               subtitle: Text(doc.data()['msg']),
//             ),
//           ));
//         }
//       });
//       return ListView(
//         children: card,
//       );
//     },
//   );
// }
