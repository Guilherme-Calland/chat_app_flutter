import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisconnectedMessage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning, color: Colors.white, size: 32, ),
            SizedBox(height: 16,),
            Text('No connection to Server.', style: TextStyle(fontSize: 32),textAlign: TextAlign.center,),
          ],
        ),
      ),
    );
  }
}
