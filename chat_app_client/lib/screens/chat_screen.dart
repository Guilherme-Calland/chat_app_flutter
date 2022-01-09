import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../controller/chat_controller.dart';
import '../model/message.dart';
import '../resources/resources.dart';
import '../widgets/message_item.dart';

class ChatScreen extends StatelessWidget {
  late IO.Socket socket;
  var chatController = ChatController();
  var msgInputController = TextEditingController();

  @override
  Widget build(_) {
    connectSocket();
    setUpSocketListener();

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Obx(
              () => Expanded(
                child: ListView.builder(
                  itemCount: chatController.messageList.length,
                  itemBuilder: (context, index) {
                    String message =
                        chatController.messageList[index].message ??
                            '[message error]';
                    String senderID =
                        chatController.messageList[index].senderID ?? '';
                    return socket.id != null
                        ? MessageItem(
                            message: message,
                            sentByMe: senderID == socket.id,
                          )
                        : NoConnectionMessage();
                  },
                ),
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
                        borderRadius: BorderRadius.circular(8), color: blue),
                    child: IconButton(
                      onPressed: () {
                        sendMessage(msgInputController.text);
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
      ),
    );
  }

  void connectSocket() {
    socket = IO.io('http://localhost:4000',
        IO.OptionBuilder().setTransports(['websocket']).build());
  }

  void setUpSocketListener() {
    socket.on('messageReceive', (data) {
      chatController.messageList.add(Message.fromJson(data));
    });

    socket.on('connected', (data) {
      print(data);
    });
  }

  void sendMessage(String text) {
    var messageJson = {"message": text, "senderID": socket.id};
    socket.emit("message", messageJson);
    chatController.messageList.add(Message.fromJson(messageJson));
    msgInputController.clear();
  }
}

class NoConnectionMessage extends StatelessWidget {
  const NoConnectionMessage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Text(
        'No connection to server.',
        style: TextStyle(fontSize: 32),
      ),
    );
  }
}
