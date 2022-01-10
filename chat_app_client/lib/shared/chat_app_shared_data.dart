import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../model/message.dart';

class ChatAppSharedData extends ChangeNotifier{
  List<Message> messageList = [];
  String socketStatus = 'disconnected';


  addMessage(Message message){
    messageList.add(message);
    notifyListeners();
  }

  changeSocketStatus(String status){
    socketStatus = status;
    notifyListeners();
  }
}