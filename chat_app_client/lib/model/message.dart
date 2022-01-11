class Message{
  String? text;
  String? sender;
  String? sendTime;

  Message({required this.text, required this.sender, required this.sendTime});

  Message.fromJson(Map<String, dynamic> data){
    text = data["text"];
    sender = data["sender"];
    sendTime = data["sendTime"];
  }

  Map messageToJson(){
    Map json = {
      "text" : text,
      "sender" : sender,
      "senderTime" : sendTime
    };
    return json;
  }
}