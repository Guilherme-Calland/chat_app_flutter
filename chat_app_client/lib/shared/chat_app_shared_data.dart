import 'package:chat_app_client/connection/connector.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../model/message.dart';

class ChatAppSharedData extends ChangeNotifier{

  List<Message> messageList = [];
  String socketStatus = "disconnected";
  int numOfUsers = 0;
  late Connector connector;

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

  initializeConnector(BuildContext buildContext){
    connector = Connector(buildContext);
  }
}