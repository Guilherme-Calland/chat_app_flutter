import 'package:chat_app_client/misc/snackbar_helper.dart';
import 'package:chat_app_client/navigation/navigation_helper.dart';
import 'package:chat_app_client/screens/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../model/message.dart';
import '../model/user.dart';
import '../resources/resources.dart';
import '../shared/chat_app_shared_data.dart';

class Connector {
  late IO.Socket socket;
  late ChatAppSharedData sharedData;
  late BuildContext buildContext;
  late SnackBarHelper snack;
  late NavigatorHelper nav;
  late String serverIP;

  Connector(this.buildContext, serverIP){
    sharedData = Provider.of<ChatAppSharedData>(buildContext, listen: false);
    connectSocket(serverIP);
    snack = SnackBarHelper(buildContext);
    nav = NavigatorHelper(buildContext);
  }

  void connectSocket(String address) {
    socket = IO.io('http://$address:3000',
        IO.OptionBuilder()
        .setTransports(['websocket'])
        .build());
    setUpSocketListener();
  }

  void setUpSocketListener() {
    socket.on('messageReceive', (jsonData) {
      sharedData.addMessage(Message.fromJson(jsonData));
    });

    socket.on('connected', (jsonData) {
      print(jsonData["connectionMessage"]);
      sharedData.changeSocketStatus(jsonData["socketStatus"]);
      sharedData.retreiveMessages(jsonData["serverMessages"]);
    });

    socket.on('connectedUsers', (numOfUsers) {
      sharedData.updateNumOfUsers(numOfUsers);
    });

    socket.on('signUp', (data) {
      if (data["socketID"] == socket.id) {
        snack.display(data["message"], darkestBlue);
        if (data["validated"] == 'yes') {
          sharedData.changeLoggedStatus(true);
          nav.popAndPush(ChatScreen.ROUTE_ID);
        }
      }

      if (data["validated"] == 'yes') {
        sharedData.updateNumOfUsers(data["numOfUsers"]);
      }
    });

    socket.on('logIn', (data) {
      if (data["socketID"] == socket.id) {
        if (data["validated"] == 'yes') {
          sharedData.changeCurrentUserTheme(data["theme"]);
          sharedData.changeLoggedStatus(true);
          nav.popAndPush(ChatScreen.ROUTE_ID);
        } else {
          snack.display(data["message"], blue);
        }
      }

      if (data["validated"] == 'yes') {
        sharedData.updateNumOfUsers(data["numOfUsers"]);
      }
    });

    socket.on('signal', (data){
      if(sharedData.loggedIn){
        var json = sharedData.currentUser.userToJson();
        socket.emit('signal', json);
      }
    });

    socket.on('updatedListNum', (data) {
      sharedData.updateNumOfUsers(data);
    });
  }

  void signUp(User user) {
    if (disconnectedFromServer()) {
      sharedData.changeSocketStatus('disconnected');
    } else {
      var jsonData = user.userToJson();
      socket.emit("signUp", jsonData);
    }
  }

  void logIn(User user) {
    if (disconnectedFromServer()) {
      sharedData.changeSocketStatus('disconnected');
    } else {
      var jsonData = user.userToJson();
      socket.emit("logIn", jsonData);
    }
  }

  bool disconnectedFromServer() => socket.id == null;

  void sendMessage(String text, User user) {
    if (text.isNotEmpty) {
      if (disconnectedFromServer()) {
        sharedData.changeSocketStatus('disconnected');
      } else {
        String sendTime = new DateTime.now().toString().substring(11, 16);
        var messageJson = {
          "text": text,
          "sender": user.userName,
          "sendTime": sendTime,
          "theme": user.theme
        };
        socket.emit("message", messageJson);
        sharedData.addMessage(Message.fromJson(messageJson));
      }
    }
  }

  void updateUser(){
    socket.emit('updateUser', sharedData.currentUser.userToJson());
  }

  void leave() {
    sharedData.changeLoggedStatus(false);
    socket.emit('leave');
  }
}
