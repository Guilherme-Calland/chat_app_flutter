import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatelessWidget {
  Color green = Color(0xff447b28);
  Color blue = Color(0xff3775c1);
  Color white = Color(0xffffffff);
  late IO.Socket socket;

  @override
  Widget build(_) {
    connectSocket();

    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return MessageItem(
                    message: 'Hello',
                    sentByMe: true,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void connectSocket() {
    socket = IO.io('http://localhost:4000',
        IO.OptionBuilder().setTransports(['websocket']).build());
  }
}

class MessageItem extends StatelessWidget {
  final String message;
  final bool sentByMe;

  MessageItem({required this.message, required this.sentByMe});

  @override
  Widget build(BuildContext context) {

    Color green = const Color(0xff447b28);
    Color blue = const Color(0xff3775c1);
    Color white = const Color(0xffffffff);
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
              color: sentByMe ? green : blue,
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
