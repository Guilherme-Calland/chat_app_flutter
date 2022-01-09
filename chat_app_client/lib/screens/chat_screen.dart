import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatScreen extends StatelessWidget {
  Color green = Color(0xff447b28);
  Color blue  = Color(0xff3775c1);
  late IO.Socket socket;

  @override
  Widget build(_) {

    connectSocket();

    return Center(
      child: Text('socket'),
    );
  }

  void connectSocket() {
    socket = IO.io(
      'http://localhost:4000',
      IO.OptionBuilder()
        .setTransports(['websocket'])
        .build()
    );
  }
}
