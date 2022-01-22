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
    socket.connect();
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
      snack.display(data["message"], darkestBlue);
      if (data["validated"] == 'yes') {
        sharedData.changeLoggedStatus(true);
        nav.popAndPush(ChatScreen.ROUTE_ID);
      }
    });

    socket.on('newUserEntered', (data){
      if(sharedData.loggedIn){
        snack.display(data["message"], green);
      };
    });

    socket.on('logIn', (data) {
      if (data["validated"] == 'yes') {
        sharedData.changeLoggedStatus(true);
        nav.popAndPush(ChatScreen.ROUTE_ID);
      } else {
        snack.display(data["message"], darkestBlue);
      }
    });

    socket.on('userLeft', (data){
      if(sharedData.loggedIn){
        snack.display(data, red);
      }
    });

    socket.on('updateNumUsers', (data){
      sharedData.updateNumOfUsers(data);
    });
  }

  void signUp(User user) {
    if (disconnectedFromServer()) {
      sharedData.changeSocketStatus('disconnected');
      nav.popToHome();
    } else {
      var jsonData = user.userToJson();
      socket.emit("signUp", jsonData);
    }
  }

  void logIn(User user) {
    if (disconnectedFromServer()) {
      sharedData.changeSocketStatus('disconnected');
      nav.popToHome();
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
        nav.popToHome();
      } else {
        String sendTime = DateTime.now().toString().substring(11, 16);
        var messageJson = {
          "text": text,
          "sender": user.userName,
          "sendTime": sendTime,
          "theme": user.theme
        };
        socket.emit("message", messageJson);
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

  void reconnect(String address){
    socket.dispose();
    connectSocket(address);
  }
}
