import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';

void main() => runApp(FlashChat());

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.dark().copyWith(
          textTheme: TextTheme(
            bodyText1: TextStyle(color: Colors.black12),
          ),
        ),
        // home: WelcomeScreen(),
        initialRoute: WelcomeScreen.page_id,
        routes: {
          WelcomeScreen.page_id: (context) => WelcomeScreen(),
          RegistrationScreen.page_id: (context) => RegistrationScreen(),
          LoginScreen.page_id: (context) => LoginScreen(),
          ChatScreen.page_id: (context) => ChatScreen(),
        });
  }
}
