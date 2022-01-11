import 'package:chat_app_client/misc/snackbar_helper.dart';
import 'package:chat_app_client/navigation/navigation_helper.dart';
import 'package:chat_app_client/screens/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../model/message.dart';
import '../model/user.dart';
import '../resources/resources.dart';
import '../shared/chat_app_shared_data.dart';

class Connector{
  late IO.Socket socket;
  late var sharedData;
  late BuildContext buildContext;
  late SnackBarHelper snack;
  late NavigatorHelper nav;
  Connector(this.buildContext){
    connectSocket();
    setUpSocketListener();
    sharedData = Provider.of<ChatAppSharedData>(buildContext, listen: false);
    snack = SnackBarHelper(buildContext);
    nav = NavigatorHelper(buildContext);
  }

  void connectSocket() {
    socket = IO.io('http://localhost:4000',
        IO.OptionBuilder().setTransports(['websocket']).build());
  }

  void setUpSocketListener() {
    socket.on('messageReceive', (jsonData) {
      sharedData
          .addMessage(Message.fromJson(jsonData));
    });

    socket.on('connected', (jsonData) {
      print(jsonData["connectionMessage"]);
      sharedData.changeSocketStatus(jsonData["socketStatus"]);
    });

    socket.on('connectedUsers', (numOfUsers){
      sharedData.updateNumOfUsers(numOfUsers);
    });

    socket.on('signUp', (data){
      if(data["socketID"] == socket.id){
        snack.display(data["message"], blue);
        if(data["validated"] == 'yes'){
          nav.popAndPush(ChatScreen.ROUTE_ID);
        }
      }else{
        snack.display(data["announcement"], green);
      }
    });

    socket.on('logIn', (data){
      if(data["socketID"] == socket.id){
        if (data["validated"] == 'yes') {
          nav.popAndPush(ChatScreen.ROUTE_ID);
        } else {
          snack.display(data["message"], blue);
        }
      }else{
        snack.display(data["announcement"], green);
      }
    });

    socket.on('leave', (data){
      if(data["socketID"] != socket.id){
        snack.display(data["message"], red);
      }
    });
  }

  void signUp(User user){
    if(disconnectedFromServer()) {
      sharedData.changeSocketStatus('disconnected');
    }else{
      var jsonData = user.userToJson();
      socket.emit("signUp", jsonData);
    }
  }

  void logIn(User user){
    if(disconnectedFromServer()) {
      sharedData.changeSocketStatus('disconnected');
    }else{
      var jsonData = user.userToJson();
      socket.emit("logIn", jsonData);
    }
  }

  bool disconnectedFromServer() => socket.id == null;

  void sendMessage(String text){
    if(text.isNotEmpty){
      if(disconnectedFromServer()){
        sharedData.changeSocketStatus('disconnected');
      }else{
        String sendTime = new DateTime.now()
            .toString()
            .substring(11, 16);
        var messageJson = {"text": text, "sender": sharedData.currentUser.userName, "sendTime": sendTime};
        socket.emit("message", messageJson);
        sharedData
            .addMessage(Message.fromJson(messageJson));
      }
    }
  }

  void leave(){
    socket.emit('leave', sharedData.currentUser.userToJson());
  }
}