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

  void initializeConnector(BuildContext buildContext){
    connector = Connector(buildContext);
  }

  bool isSocketConnected(){
    return socketStatus == "connected";
  }

  void addMessage(Message message){
    messageList.insert(0, message);
    notifyListeners();
  }

  void changeSocketStatus(String status){
    socketStatus = status;
    notifyListeners();
  }

  void emptyAllMessages(){
    messageList.clear();
    notifyListeners();
  }

  void updateNumOfUsers(n){
    numOfUsers = n;
    notifyListeners();
  }

  void registerUser(User user){
    connector.registerUser(user);
  }

}