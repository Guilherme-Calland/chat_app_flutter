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

  @override
  Widget build(BuildContext buildContext) {
    nav = NavigatorHelper(buildContext);
    return Consumer<ChatAppSharedData>(
      builder: (_, data, __) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              '${data.currentUser.userName}', style: TextStyle(fontSize: 24),),
            centerTitle: true,
            backgroundColor: data.currentUser.themeToColor(),
            leading: GestureDetector(
              onTap: () {
                nav.pop();
                data.connector.leave();
              },
              child: Icon(
                Icons.arrow_back,
                color: white,
              ),
            ),
          ),
          body: data.isSocketConnected()
              ? Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            'Connected Users: ${data.numOfUsers}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          reverse: true,
                          itemCount: data.messageList.length,
                          itemBuilder: (context, index) {
                            Message msg = data.messageList[index];
                            String text = msg.text ?? '';
                            bool sentByMe =
                                msg.sender == data.currentUser.userName;
                            String sendTime = msg.sendTime ?? '';
                            return MessageItem(
                                text: text,
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
              : DisconnectedMessage(),
        );
      },
    );
  }

  void sendMessage(String text, ChatAppSharedData sharedData) {
    sharedData.connector.sendMessage(text);
    msgInputController.clear();
  }
}
