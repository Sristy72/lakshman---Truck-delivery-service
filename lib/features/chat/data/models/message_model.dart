class MessageModel {
  final String id;
  final String text;
  final String userId;
  final String date;
  final bool read;
  final ChatUser user;

  MessageModel({
    required this.id,
    required this.text,
    required this.userId,
    required this.date,
    required this.read,
    required this.user,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
    id: json['_id'] ?? '',
    text: json['text'] ?? '',
    userId: json['user'] is Map
        ? json['user']['_id'] ?? ''
        : json['user'] ?? '', // sometimes user field is just ID
    date: json['date'] ?? '',
    read: json['read'] ?? false,
    user: ChatUser.fromJson(json['user']),
  );

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'text': text,
      'user': user.toJson(),
      'date': date,
      'read': read,
    };
  }
}

/// Simple ChatUser model used by MessageModel
class ChatUser {
  final String id;
  final String name;
  final String role;
  final Avatar avatar;

  ChatUser({
    required this.id,
    required this.name,
    required this.role,
    required this.avatar,
  });

  factory ChatUser.fromJson(dynamic json) {
    if (json is String) {
      // sometimes only id is provided
      return ChatUser(
        id: json,
        name: '',
        role: '',
        avatar: Avatar(publicId: '', url: ''),
      );
    }
    if (json is Map<String, dynamic>) {
      return ChatUser(
        id: json['_id'] ?? '',
        name: json['name'] ?? '',
        role: json['role'] ?? '',
        avatar: Avatar.fromJson(json['avatar'] ?? {}),
      );
    }
    return ChatUser(
      id: '',
      name: '',
      role: '',
      avatar: Avatar(publicId: '', url: ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'role': role, 'avatar': avatar.toJson()};
  }
}

class Avatar {
  final String publicId;
  final String url;

  Avatar({required this.publicId, required this.url});

  factory Avatar.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Avatar(publicId: '', url: '');
    return Avatar(publicId: json['public_id'] ?? '', url: json['url'] ?? '');
  }

  Map<String, dynamic> toJson() => {'public_id': publicId, 'url': url};
}
