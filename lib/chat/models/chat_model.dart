class ChatGroupModel {
  final String id;
  final String name;
  final String description;
  final String lastMessage;
  final String lastSender;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool online;
  final String initials;

  const ChatGroupModel({
    required this.id,
    required this.name,
    required this.description,
    required this.lastMessage,
    required this.lastSender,
    required this.lastMessageTime,
    required this.unreadCount,
    required this.online,
    required this.initials,
  });
}

class ChatMessageModel {
  final String id;
  final String sender;
  final String message;
  final DateTime time;
  final bool isMe;

  const ChatMessageModel({
    required this.id,
    required this.sender,
    required this.message,
    required this.time,
    required this.isMe,
  });
}
