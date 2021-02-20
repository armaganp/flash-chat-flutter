import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ### AUTH VARS
final FirebaseAuth mAuth = FirebaseAuth.instance; // instance of auth
final User currentUser = mAuth.currentUser; // current user
User vUser; // user variable
StreamSubscription userStateListener; // auth changes listener
UserCredential gUserCredential; // credentials after authorization

//### FIRE STORE VARS
FirebaseFirestore db = FirebaseFirestore.instance;
// fireStore db handler
