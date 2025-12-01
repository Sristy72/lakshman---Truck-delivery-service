class Message {
  final String id;
  final String senderName;
  final String senderAvatar;
  final String content;
  final String timestamp;
  final bool isFromMe;

  Message({
    required this.id,
    required this.senderName,
    required this.senderAvatar,
    required this.content,
    required this.timestamp,
    required this.isFromMe,
  });
}

class Conversation {
  final String id;
  final String name;
  final String avatar;
  final String lastMessage;
  final String lastMessageTime;
  final List<Message> messages;

  Conversation({
    required this.id,
    required this.name,
    required this.avatar,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.messages,
  });
}
