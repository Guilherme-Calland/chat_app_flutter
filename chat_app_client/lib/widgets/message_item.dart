import 'package:flutter/material.dart';
import '../resources/resources.dart';

class MessageItem extends StatelessWidget {
  final String text;
  final bool sentByMe;
  final String sendTime;
  final Color color;

  MessageItem({required this.text, required this.sentByMe, required this.sendTime, required this.color});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: sentByMe ? Alignment.centerLeft : Alignment.centerRight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: color,
            ),
            child: Text(
              text,
              style: TextStyle(color: white, fontSize: 18),
            ),
          ),
          Text(
            sendTime,
            style: TextStyle(
              color: white.withOpacity(0.7),
              fontSize: 10,
            ),
          ),
          const SizedBox(
            width: 5,
          ),
        ],
      ),
    );
  }
}
