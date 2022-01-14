import 'package:chat_app_client/shared/chat_app_shared_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../misc/utils.dart';
import '../model/message.dart';
import '../model/user.dart';
import '../navigation/navigation_helper.dart';
import '../resources/resources.dart';
import '../widgets/custom_arrow_button.dart';
import '../widgets/disconnected_message.dart';
import '../widgets/message_item.dart';
import '../widgets/user_theme_collor_control.dart';

class ChatScreen extends StatelessWidget {
  static const ROUTE_ID = 'chat_screen';
  var msgInputController = TextEditingController();
  late NavigatorHelper nav;
  var focusNode = FocusNode();

  @override
  Widget build(BuildContext buildContext) {
    nav = NavigatorHelper(buildContext);
    return Consumer<ChatAppSharedData>(
      builder: (_, data, __) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                '${data.currentUser.userName}',
                style: const TextStyle(fontSize: 24),
              ),
              centerTitle: true,
              backgroundColor: themeToColor(data.currentUser.theme),
              actions: [
                UserThemeColorControl(
                  callback: () {
                    focusNode.requestFocus();
                  },
                ),
              ],
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
            body: data.socketStatus == 'connected'
                ? Container(
                    padding: const EdgeInsets.only(bottom: 8, top: 4, left: 16, right: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Connected Users: ${data.numOfUsers}',
                          style: TextStyle(fontSize: 16, color: white),
                        ),
                        Expanded(
                          child: ListView.builder(
                            reverse: true,
                            itemCount: data.messageList.length,
                            itemBuilder: (context, index) {
                              Message msg = data.messageList[index];
                              String sender = msg.sender ?? '';
                              String text = msg.text ?? '';
                              bool sentByMe =
                                  sender == data.currentUser.userName;
                              String sendTime = msg.sendTime ?? '';
                              Color color = themeToColor(msg.theme);
                              return MessageItem(
                                  text: text,
                                  sentByMe: sentByMe,
                                  sendTime: sendTime,
                                  color: color,
                                  sender: sender,
                              );
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: TextField(
                            keyboardType: TextInputType.visiblePassword,
                            focusNode: focusNode,
                            textInputAction: TextInputAction.none,
                            onSubmitted: (text) => sendMessage(text, data),
                            autofocus: true,
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
                                margin: const EdgeInsets.only(right: 10),
                                child: CustomArrowButton(
                                    onPressed: () => sendMessage(
                                        msgInputController.text, data)),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : DisconnectedMessage(data),
          ),
        );
      },
    );
  }

  void sendMessage(String text, ChatAppSharedData sharedData) {
    User user = sharedData.currentUser;
    sharedData.connector.sendMessage(text, user);
    msgInputController.clear();
  }
}
