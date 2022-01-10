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
  Widget build(BuildContext buildContext) {
    providerData = Provider.of<ChatAppSharedData>(buildContext, listen: false);
    connectSocket();
    setUpSocketListener();

    return Scaffold(
      body: Consumer<ChatAppSharedData>(
        builder: (_, data, __) {
          return data.socketStatus == 'connected'
              ? Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text('Connected Users: ${data.numOfUsers}'
                          ,style: TextStyle(
                              fontSize: 16
                            ),),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          reverse: true,
                          itemCount: data.messageList.length,
                          itemBuilder: (context, index) {
                            Message item = data.messageList[index];

                            String message = item.message ??
                                '[message error]';
                            bool sentByMe =
                                item.senderID == socket.id;
                            String sendTime =
                                item.sendTime ?? '';
                            return MessageItem(
                              message: message,
                              sentByMe: sentByMe,
                              sendTime: sendTime
                            );
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8),
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
                                  sendMessage(msgInputController.text, buildContext);
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

  void setUpSocketListener() {
    socket.on('messageReceive', (jsonData) {
      providerData
          .addMessage(Message.fromJson(jsonData));
    });

    socket.on('connected', (jsonData) {
      print(jsonData["connectionMessage"]);
      providerData.changeSocketStatus(jsonData["socketStatus"]);
    });

    socket.on('connectedUsers', (numOfUsers){
      providerData.updateNumOfUsers(numOfUsers);
    });
  }

  void sendMessage(String text, BuildContext context) {
    if(text.isNotEmpty){
      if(socket.id == null){
        providerData.changeSocketStatus('disconnected');
        providerData.emptyAllMessages();
      }else{
        String sendTime = new DateTime.now()
            .toString()
            .substring(11, 16);
        var messageJson = {"message": text, "senderID": socket.id, "sendTime": sendTime};
        socket.emit("message", messageJson);
        providerData
            .addMessage(Message.fromJson(messageJson));
      }
      msgInputController.clear();
    }
  }
}

