import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    print('firebase init ok..');
  } catch (e) {
    print(e);
  }
  runApp(FlashChat());
}

class FlashChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        visualDensity: VisualDensity.adaptivePlatformDensity,
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
        // LoginScreen.page_id: (context) => LoginScreen(),
        ChatScreen.page_id: (context) => ChatScreen(),
      },
    );
  }
}
