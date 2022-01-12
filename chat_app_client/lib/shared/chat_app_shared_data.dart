import 'package:chat_app_client/connection/connector.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../model/message.dart';
import '../model/user.dart';
import '../resources/resources.dart';

class ChatAppSharedData extends ChangeNotifier{

  List<Message> messageList = [];
  String socketStatus = "disconnected";
  int numOfUsers = 0;
  late Connector connector;
  late User currentUser;
  bool colorOptionsEnabled = false;

  void initializeConnector(BuildContext buildContext){
    connector = Connector(buildContext);
  }

  void retreiveMessages(List<dynamic> data){
    List<Message> tempList = [];
    for (var m in data) {
      tempList.add(Message.fromJson(m));
    }
    messageList = tempList;
    notifyListeners();
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

  void signUp(User user){
    connector.signUp(user);
  }

  void logIn(User user){
    connector.logIn(user);
  }

  void changeCurrentUser(User user){
    currentUser = user;
    notifyListeners();
  }

  void toggleColorOptions(){
    colorOptionsEnabled = !colorOptionsEnabled;
    notifyListeners();
  }

  void changeCurrentUserTheme(String theme){
    currentUser.theme = theme;
    connector.updateUser();
    notifyListeners();
  }

}