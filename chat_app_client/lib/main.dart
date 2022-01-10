import 'package:chat_app_client/screens/chat_screen.dart';
import 'package:chat_app_client/screens/home_screen.dart';
import 'package:chat_app_client/shared/chat_app_shared_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(ChatApp());

class ChatApp extends StatelessWidget {
  @override
  Widget build(_) {
    return ChangeNotifierProvider(
      create: (context) => ChatAppSharedData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Socket Chat App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.black,
          textTheme: TextTheme(
            bodyText2: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        home: Scaffold(
          body: HomeScreen(),
        ),
      ),
    );
  }
}
