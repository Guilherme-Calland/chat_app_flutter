import 'package:chat_app_client/shared/chat_app_shared_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../connection/connector.dart';
import '../model/message.dart';
import '../navigation/navigation_helper.dart';
import '../resources/resources.dart';
import '../widgets/disconnected_message.dart';
import '../widgets/message_item.dart';

class ChatScreen extends StatelessWidget {
  static const ROUTE_ID = 'chat_screen';
  var msgInputController = TextEditingController();
  late NavigatorHelper nav;
  late var providerData;

  @override
  Widget build(BuildContext buildContext) {
    nav = NavigatorHelper(buildContext);
    providerData = Provider.of<ChatAppSharedData>(buildContext, listen : false);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff000000),
          leading: GestureDetector(
            onTap: () {
              nav.pop();
            },
            child: Icon(
              Icons.arrow_back,
              color: white,
            ),
          ),
        ),
        body: Consumer<ChatAppSharedData>(
        builder: (_, data, __)
    {
      return data.isSocketConnected()
          ? Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('Connected Users: ${data.numOfUsers}'
                  , style: TextStyle(
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
                      item.senderID == data.connector.socket.id;
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
                        sendMessage(msgInputController.text, data);
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
    },)
    ,
    );
  }

  void sendMessage(String text, ChatAppSharedData sharedData) {
    sharedData.connector.sendMessage(text);
    msgInputController.clear();
  }
}

