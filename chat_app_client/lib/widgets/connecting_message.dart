import 'package:flutter/material.dart';

class ConnectingMessage extends StatelessWidget {
  @override
  Widget build(_) {
    return Center(
      child: Text('Waiting for server...', style: TextStyle(fontSize: 32),),
    );
  }
}
