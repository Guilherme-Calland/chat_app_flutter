import 'dart:ui';

import '../resources/resources.dart';

class User{
  String? userName;
  String? password;
  String theme;

  User(this.userName, this.password, {this.theme= 'blue'});

  Map userToJson(){
    Map json = {
      "userName" : userName,
      "password" : password,
      "theme" : theme
    };
    return json;
  }
}