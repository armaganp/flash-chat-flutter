import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    runApp(FlashChat());
    print('firebase init ok..');
  } catch (e) {
    print(e);
  }
}

class FlashChat extends StatelessWidget {
  @override
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          bodyText1: TextStyle(
            color: Colors.black12,
          ),
        ),
      ),
      // home: initialScreen,
      initialRoute: WelcomeScreen.page_id,
      routes: {
        WelcomeScreen.page_id: (context) => WelcomeScreen(),
        RegistrationScreen.page_id: (context) => RegistrationScreen(),
        LoginScreen.page_id: (context) => LoginScreen(),
        ChatScreen.page_id: (context) => ChatScreen(),
      },
    );
  }
}
