class ChatModel {
  final String id;
  final String name;
  final String? seller;
  final String? user;
  final List<ChatMessageModel> messages;
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
            ?.map((e) => ChatMessageModel.fromJson(e))
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
        return url.isNotEmpty ? url : ''; // fallback to empty string to show first letter
      }
    } catch (_) {}
    return ''; // fallback to empty string to show first letter
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

/// Nested message model for ChatModel
class ChatMessageModel {
  final String id;
  final String text;
  final ChatMessageUser user;
  final String date;
  final bool read;

  ChatMessageModel({
    required this.id,
    required this.text,
    required this.user,
    required this.date,
    required this.read,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    // Handle user field - can be either a String (ID only) or Map (populated user object)
    final userData = json['user'];
    ChatMessageUser user;
    
    if (userData is String) {
      // User is just an ID string - create minimal user object
      user = ChatMessageUser(
        id: userData,
        name: 'User',
        role: '',
        avatar: ChatAvatar(publicId: '', url: ''),
      );
    } else if (userData is Map<String, dynamic>) {
      // User is a populated object
      user = ChatMessageUser.fromJson(userData);
    } else {
      // Fallback for null or unexpected format
      user = ChatMessageUser(
        id: '',
        name: 'Unknown',
        role: '',
        avatar: ChatAvatar(publicId: '', url: ''),
      );
    }
    
    return ChatMessageModel(
      id: json['_id'] ?? '',
      text: json['text'] ?? '',
      user: user,
      date: json['date'] ?? '',
      read: json['read'] ?? false,
    );
  }
}

/// Nested user inside message for ChatModel
class ChatMessageUser {
  final String id;
  final String name;
  final String role;
  final ChatAvatar avatar;

  ChatMessageUser({
    required this.id,
    required this.name,
    required this.role,
    required this.avatar,
  });

  factory ChatMessageUser.fromJson(Map<String, dynamic> json) => ChatMessageUser(
    id: json['_id'] ?? '',
    name: json['name'] ?? '',
    role: json['role'] ?? '',
    avatar: ChatAvatar.fromJson(json['avatar']),
  );
}

/// Avatar model for user in ChatModel
class ChatAvatar {
  final String publicId;
  final String url;

  ChatAvatar({required this.publicId, required this.url});

  factory ChatAvatar.fromJson(dynamic json) {
    // Handle null
    if (json == null) return ChatAvatar(publicId: '', url: '');
    
    // Handle if avatar is a String (direct URL)
    if (json is String) {
      return ChatAvatar(publicId: '', url: json);
    }
    
    // Handle if avatar is a Map (object with url and public_id)
    if (json is Map<String, dynamic>) {
      return ChatAvatar(
        publicId: json['public_id'] ?? '',
        url: json['url'] ?? '',
      );
    }
    
    // Fallback for unexpected format
    return ChatAvatar(publicId: '', url: '');
  }
}
