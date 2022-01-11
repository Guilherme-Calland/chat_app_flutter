import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../model/message.dart';
import '../model/user.dart';
import '../shared/chat_app_shared_data.dart';

class Connector{
  late IO.Socket socket;
  late var providerData;

  Connector(BuildContext buildContext){
    connectSocket();
    setUpSocketListener();
    providerData = Provider.of<ChatAppSharedData>(buildContext, listen: false);
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

    socket.on('validateUser', (data){
      print(data);
    });
  }

  void registerUser(User user){
    if(disconnectedFromServer()) {
      providerData.changeSocketStatus('disconnected');
      providerData.emptyAllMessages();
    }else{
      var jsonData = user.userToJson();
      socket.emit("verifyUser", jsonData);
    }
  }

  bool disconnectedFromServer() => socket.id == null;

  void sendMessage(String text){
    if(text.isNotEmpty){
      if(disconnectedFromServer()){
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
    }
  }
}