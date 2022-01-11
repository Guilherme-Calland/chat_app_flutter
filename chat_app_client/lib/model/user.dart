class User{
  String? userName;
  String? password;

  User(this.userName, this.password);

  Map userToJson(){
    Map json = {
      "userName" : this.userName,
      "password" : this.password
    };
    return json;
  }
}