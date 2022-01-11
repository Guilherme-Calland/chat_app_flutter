import 'package:chat_app_client/connection/connector.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../model/message.dart';
import '../model/user.dart';

class ChatAppSharedData extends ChangeNotifier{

  List<Message> messageList = [];
  String socketStatus = "disconnected";
  int numOfUsers = 0;
  late Connector connector;

  initializeConnector(BuildContext buildContext){
    connector = Connector(buildContext);
  }

  isSocketConnected(){
    return socketStatus == "connected";
  }

  addMessage(Message message){
    messageList.insert(0, message);
    notifyListeners();
  }

  changeSocketStatus(String status){
    socketStatus = status;
    notifyListeners();
  }

  emptyAllMessages(){
    messageList.clear();
    notifyListeners();
  }

  updateNumOfUsers(n){
    numOfUsers = n;
    notifyListeners();
  }

  registerUser(User user){
    connector.registerUser(user);
  }
}