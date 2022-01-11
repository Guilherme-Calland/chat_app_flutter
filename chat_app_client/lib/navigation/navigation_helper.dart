import 'package:flutter/cupertino.dart';

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
}