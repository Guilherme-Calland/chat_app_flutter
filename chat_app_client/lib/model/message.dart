class Message{
  String? message;
  String? senderID;
  String? sendTime;

  Message({required this.message, required this.senderID, required this.sendTime});

  Message.fromJson(Map<String, dynamic> data){
    this.message = data["message"];
    this.senderID = data["senderID"];
    this.sendTime = data["sendTime"];
  }

  Map messageToJson(){
    Map json = {
      "message" : this.message,
      "senderId" : this.senderID,
      "senderTime" : this.sendTime
    };
    return json;
  }
}