import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth mAuth = FirebaseAuth.instance;
// User vUser = mAuth.currentUser;
User vUser;
StreamSubscription userStateListener;
UserCredential userCredential;
