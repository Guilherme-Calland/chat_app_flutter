import 'package:chat_app_client/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigatorHelper{
  late BuildContext buildContext;
  NavigatorHelper(this.buildContext);

  void push(String route){
    Navigator.pushNamed(buildContext, route);
  }

  void popAndPush(String route){
    Navigator.popAndPushNamed(buildContext, route);
  }

  void pop(){
    Navigator.pop(buildContext);
  }

  void popToHome(){
    Navigator.of(buildContext).popUntil(ModalRoute.withName(HomeScreen.ROUTE_ID));
  }
}

