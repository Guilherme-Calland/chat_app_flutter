import 'package:chat_app_client/resources/resources.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(_) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Chat App',
            style: TextStyle(fontSize: 80),
          ),
          SizedBox(height: 64,),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: blue,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 80,
                  vertical: 20,
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Text('Sign Up', style: TextStyle(
                  fontSize: 32
                ),),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: darkBlue,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 80,
                  vertical: 20,
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Text('Log in', style: TextStyle(
                  fontSize: 32
                ),),
              ),
            ],
          )
        ],
      ),
    );
  }
}
