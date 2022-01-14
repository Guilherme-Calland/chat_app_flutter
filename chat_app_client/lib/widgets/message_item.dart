import 'package:chat_app_client/misc/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../resources/resources.dart';

class MessageItem extends StatelessWidget {
  final String text;
  final bool sentByMe;
  final String sendTime;
  final Color color;
  final String sender;

  MessageItem(
      {required this.text,
      required this.sentByMe,
      required this.sendTime,
      required this.color,
      required this.sender});

  @override
  Widget build(BuildContext buildContext) {
    return Align(
      alignment: sentByMe ? Alignment.centerLeft : Alignment.centerRight,
      child: Column(
        crossAxisAlignment:
            sentByMe ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: [
          Container(
            margin: sentByMe
                ? const EdgeInsets.only(left: 12, top: 12)
                : const EdgeInsets.only(right: 12, top: 12),
            child: Text(
              sender,
              textAlign: sentByMe ? TextAlign.start : TextAlign.end,
              style: TextStyle(fontSize: 16, color: white.withOpacity(0.7)),
            ),
          ),
          sentByMe
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          top: 2, bottom: 8, left: 10, right: 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: color,
                      ),
                      child: Container(
                        constraints: BoxConstraints(
                            maxWidth: screenWidth(buildContext) * 0.6),
                        child: Text(
                          text,
                          style: TextStyle(color: white, fontSize: 18),
                        ),
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
                      width: 4,
                    ),
                  ],
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      sendTime,
                      style: TextStyle(
                        color: white.withOpacity(0.7),
                        fontSize: 10,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          top: 2, bottom: 8, left: 10, right: 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: color,
                      ),
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: screenWidth(buildContext) * 0.6,
                        ),
                        child: Text(
                          text,
                          style: TextStyle(color: white, fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                  ],
                ),
        ],
      ),
    );
  }
}
