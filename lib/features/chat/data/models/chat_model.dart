class ChatModel {
  final String id;
  final String name;
  final String? seller;
  final String? user;
  final List<MessageModel> messages;
  final String createdAt;
  final String updatedAt;

  ChatModel({
    required this.id,
    required this.name,
    this.seller,
    this.user,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
    id: json['_id'] ?? '',
    name: json['name'] ?? '',
    seller: json['seller'],
    user: json['user'],
    messages:
        (json['messages'] as List<dynamic>?)
            ?.map((e) => MessageModel.fromJson(e))
            .toList() ??
        [],
    createdAt: json['createdAt'] ?? '',
    updatedAt: json['updatedAt'] ?? '',
  );

  /// 🟢 Computed Getters for UI
  String get lastMessage =>
      messages.isNotEmpty ? messages.last.text : 'No messages yet';

  String get avatar {
    try {
      if (messages.isNotEmpty) {
        final url = messages.last.user.avatar.url;
        return url.isNotEmpty ? url : 'https://i.pravatar.cc/150'; // fallback
      }
    } catch (_) {}
    return 'https://i.pravatar.cc/150';
  }

  String get time {
    if (messages.isEmpty) return '';
    final dateStr = messages.last.date;
    if (dateStr.isEmpty) return '';
    try {
      final date = DateTime.parse(dateStr).toLocal();
      final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
      final minute = date.minute.toString().padLeft(2, '0');
      final ampm = date.hour >= 12 ? 'pm' : 'am';
      return '$hour:$minute $ampm';
    } catch (_) {
      return '';
    }
  }
}

/// Nested message model
class MessageModel {
  final String id;
  final String text;
  final MessageUser user;
  final String date;
  final bool read;

  MessageModel({
    required this.id,
    required this.text,
    required this.user,
    required this.date,
    required this.read,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    id: json['_id'] ?? '',
    text: json['text'] ?? '',
    user: MessageUser.fromJson(json['user']),
    date: json['date'] ?? '',
    read: json['read'] ?? false,
  );
}

/// Nested user inside message
class MessageUser {
  final String id;
  final String name;
  final String role;
  final Avatar avatar;

  MessageUser({
    required this.id,
    required this.name,
    required this.role,
    required this.avatar,
  });

  factory MessageUser.fromJson(Map<String, dynamic> json) => MessageUser(
    id: json['_id'] ?? '',
    name: json['name'] ?? '',
    role: json['role'] ?? '',
    avatar: Avatar.fromJson(json['avatar']),
  );
}

/// Avatar model for user
class Avatar {
  final String publicId;
  final String url;

  Avatar({required this.publicId, required this.url});

  factory Avatar.fromJson(Map<String, dynamic> json) =>
      Avatar(publicId: json['public_id'] ?? '', url: json['url'] ?? '');
}
