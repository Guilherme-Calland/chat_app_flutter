import 'package:flutter/material.dart';
import '../resources/resources.dart';

class MessageItem extends StatelessWidget {
  final String message;
  final bool sentByMe;

  MessageItem({required this.message, required this.sentByMe});

  @override
  Widget build(BuildContext context) {
    String time = new DateTime.now()
        .toString()
        .substring(11, 16);

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
              color: sentByMe ? blue : green,
            ),
            child: Text(
              message,
              style: TextStyle(color: white, fontSize: 18),
            ),
          ),
          Text(
            time,
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
