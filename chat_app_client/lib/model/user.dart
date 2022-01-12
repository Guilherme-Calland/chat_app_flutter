import 'dart:ui';

import '../resources/resources.dart';

class User{
  String? userName;
  String? password;
  String themeColor;

  User(this.userName, this.password, {this.themeColor = 'blue'});

  Map userToJson(){
    Map json = {
      "userName" : this.userName,
      "password" : this.password
    };
    return json;
  }

  Color themeToColor(){
    Color color = blue;
    switch(themeColor){
      case 'blue' : color = blue; break;
      case 'red' : color = red; break;
    }
    return color;
  }
}