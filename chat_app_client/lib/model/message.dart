class Message{
  String? text;
  String? sender;
  String? sendTime;
  String? theme;

  Message({required this.text, required this.sender, required this.sendTime, required this.theme});

  Message.fromJson(Map data){
    text = data["text"];
    sender = data["sender"];
    sendTime = data["sendTime"];
    theme = data["theme"];
  }

  Map messageToJson(){
    Map json = {
      "text" : text,
      "sender" : sender,
      "senderTime" : sendTime,
      "theme" : theme
    };
    return json;
  }
}