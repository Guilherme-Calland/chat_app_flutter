class Message{
  String? message;
  String? senderID;

  Message({required this.message, required this.senderID});

  Message.fromJson(Map<String, dynamic> data){
    this.message = data["message"];
    this.senderID = data["senderID"];
  }
}