import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth mAuth = FirebaseAuth.instance;
final User vUser = mAuth.currentUser;
StreamSubscription userStateListener;
UserCredential userCredential;
