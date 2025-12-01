class NotificationModel {
  final String id;
  final NotificationUser user;
  final String company;
  final String? dispatcher;
  final String title;
  final String message;
  final String type;
  final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;

  const NotificationModel({
    required this.id,
    required this.user,
    required this.company,
    this.dispatcher,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'] ?? '',
      user: NotificationUser.fromJson(json['user'] is Map<String, dynamic> 
          ? json['user'] as Map<String, dynamic> 
          : {}),
      company: json['company'] ?? '',
      dispatcher: json['dispatcher'],
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? '',
      isRead: json['isRead'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user.toJson(),
      'company': company,
      'dispatcher': dispatcher,
      'title': title,
      'message': message,
      'type': type,
      'isRead': isRead,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Helper method to get formatted time
  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  // Helper method to get notification icon based on type
  String get typeIcon {
    switch (type.toLowerCase()) {
      case 'user':
        return '👤';
      case 'dispatcher':
        return '🚛';
      case 'company':
        return '🏢';
      default:
        return '🔔';
    }
  }
}

class NotificationUser {
  final String id;
  final String name;
  final String email;
  final String role;
  final NotificationAvatar avatar;

  const NotificationUser({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.avatar,
  });

  factory NotificationUser.fromJson(Map<String, dynamic> json) {
    return NotificationUser(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      avatar: NotificationAvatar.fromJson(
        json['avatar'] is Map<String, dynamic> 
            ? json['avatar'] as Map<String, dynamic> 
            : {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'role': role,
      'avatar': avatar.toJson(),
    };
  }
}

class NotificationAvatar {
  final String publicId;
  final String url;

  const NotificationAvatar({
    required this.publicId,
    required this.url,
  });

  factory NotificationAvatar.fromJson(Map<String, dynamic> json) {
    return NotificationAvatar(
      publicId: json['public_id'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'public_id': publicId,
      'url': url,
    };
  }

  // Helper to check if avatar is available
  bool get hasAvatar => url.isNotEmpty;
}
