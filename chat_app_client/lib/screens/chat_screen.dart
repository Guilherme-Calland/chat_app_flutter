import 'package:chat_app_client/shared/chat_app_shared_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../model/message.dart';
import '../resources/resources.dart';
import '../widgets/disconnected_message.dart';
import '../widgets/message_item.dart';

class ChatScreen extends StatelessWidget {
  late IO.Socket socket;
  var msgInputController = TextEditingController();
  late var providerData;

  @override
  Widget build(BuildContext context) {
    providerData = Provider.of<ChatAppSharedData>(context, listen: false);
    connectSocket();
    setUpSocketListener(context);

    return Scaffold(
      body: Consumer<ChatAppSharedData>(
        builder: (_, data, __) {
          return data.socketStatus == 'connected'
              ? Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: data.messageList.length,
                          itemBuilder: (context, index) {
                            String message = data.messageList[index].message ??
                                '[message error]';
                            String senderID =
                                data.messageList[index].senderID ?? '';
                            return MessageItem(
                              message: message,
                              sentByMe: senderID == socket.id,
                            );
                          },
                        ),
                      ),
                      Container(
                        child: TextField(
                          style: TextStyle(color: white),
                          cursorColor: blue,
                          controller: msgInputController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: white),
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: white),
                                borderRadius: BorderRadius.circular(10)),
                            suffixIcon: Container(
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: blue),
                              child: IconButton(
                                onPressed: () {
                                  sendMessage(msgInputController.text, context);
                                },
                                icon: Icon(
                                  Icons.send,
                                  color: white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : DisconnectedMessage();
        },
      ),
    );
  }

  void connectSocket() {
    socket = IO.io('http://localhost:4000',
        IO.OptionBuilder().setTransports(['websocket']).build());
  }

  void setUpSocketListener(BuildContext context) {
    socket.on('messageReceive', (jsonData) {
      providerData
          .addMessage(Message.fromJson(jsonData));
    });

    socket.on('connected', (jsonData) {
      print(jsonData["connectionMessage"]);
      providerData.changeSocketStatus(jsonData["socketStatus"]);
    });
  }

  void sendMessage(String text, BuildContext context) {
    var messageJson = {"message": text, "senderID": socket.id};
    socket.emit("message", messageJson);
    providerData
        .addMessage(Message.fromJson(messageJson));
    msgInputController.clear();
  }
}

