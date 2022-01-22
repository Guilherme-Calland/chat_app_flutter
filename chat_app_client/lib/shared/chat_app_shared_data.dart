import 'package:chat_app_client/connection/connector.dart';
import 'package:chat_app_client/misc/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../model/message.dart';
import '../model/user.dart';
import '../resources/resources.dart';

class ChatAppSharedData extends ChangeNotifier{

  List<Message> messageList = [];
  String socketStatus = "disconnected";
  bool loggedIn = false;
  int numOfUsers = 0;
  late User currentUser;
  bool colorOptionsEnabled = false;
  bool waitingInitialConnection = true;
  late Connector connector;
  late SharedPreferences storedData;

  void retreiveMessages(List<dynamic> data){
    List<Message> tempList = [];
    for (var m in data) {
      tempList.insert(0, Message.fromJson(m));
    }
    messageList = tempList;
    notifyListeners();
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

  void changeLoggedStatus(bool b){
    loggedIn = b;
    notifyListeners();
  }

  void onDoneSleep(){
    waitingInitialConnection = false;
    notifyListeners();
  }

  void initializeConnection(BuildContext buildContext) async{
    storedData = await SharedPreferences.getInstance();
    var serverIP = storedData.getString('serverIP') ?? 'localhost';
    connector = Connector(buildContext, serverIP);
  }

  void connectNewSocket(String address){
    storedData.setString('serverIP', address);
    connector.reconnect(address);
  }
}