class MessageModel {
  final String id;
  final String sender;
  final String message;
  final String time;
  final bool isMe;

  MessageModel({
    required this.id,
    required this.sender,
    required this.message,
    required this.time,
    required this.isMe,
  });

  factory MessageModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MessageModel(
      id: json["id"].toString(),
      sender: json["sender"] ?? "",
      message: json["message"] ?? "",
      time: json["time"] ?? "",
      isMe: json["is_me"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "sender": sender,
      "message": message,
      "time": time,
      "is_me": isMe,
    };
  }
}
