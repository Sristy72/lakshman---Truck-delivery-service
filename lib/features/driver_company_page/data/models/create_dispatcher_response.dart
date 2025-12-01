class CreateDispatcherResponse {
  final String id;
  final UserInfo user;
  final CompanyInfo company;
  final DateTime createdAt;
  final DateTime updatedAt;

  CreateDispatcherResponse({
    required this.id,
    required this.user,
    required this.company,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CreateDispatcherResponse.fromJson(Map<String, dynamic> json) {
    return CreateDispatcherResponse(
      id: json['_id'] ?? '',
      user: UserInfo.fromJson(json['user'] ?? {}),
      company: CompanyInfo.fromJson(json['company'] ?? {}),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user.toJson(),
      'company': company.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class UserInfo {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final AvatarInfo avatar;
  final VerificationInfo verificationInfo;
  final String stripeAccountId;
  final bool isStripeOnboarded;
  final String passwordResetToken;
  final String refreshToken;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserInfo({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.avatar,
    required this.verificationInfo,
    required this.stripeAccountId,
    required this.isStripeOnboarded,
    required this.passwordResetToken,
    required this.refreshToken,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      avatar: AvatarInfo.fromJson(json['avatar'] ?? {}),
      verificationInfo: VerificationInfo.fromJson(json['verificationInfo'] ?? {}),
      stripeAccountId: json['stripeAccountId'] ?? '',
      isStripeOnboarded: json['isStripeOnboarded'] ?? false,
      passwordResetToken: json['password_reset_token'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
      'avatar': avatar.toJson(),
      'verificationInfo': verificationInfo.toJson(),
      'stripeAccountId': stripeAccountId,
      'isStripeOnboarded': isStripeOnboarded,
      'password_reset_token': passwordResetToken,
      'refreshToken': refreshToken,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class AvatarInfo {
  final String publicId;
  final String url;

  AvatarInfo({
    required this.publicId,
    required this.url,
  });

  factory AvatarInfo.fromJson(Map<String, dynamic> json) {
    return AvatarInfo(
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
}

class VerificationInfo {
  final bool verified;
  final String token;

  VerificationInfo({
    required this.verified,
    required this.token,
  });

  factory VerificationInfo.fromJson(Map<String, dynamic> json) {
    return VerificationInfo(
      verified: json['verified'] ?? false,
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'verified': verified,
      'token': token,
    };
  }
}

class CompanyInfo {
  final String id;
  final String name;
  final String email;
  final dynamic logo;
  final String owner;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  CompanyInfo({
    required this.id,
    required this.name,
    required this.email,
    this.logo,
    required this.owner,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CompanyInfo.fromJson(Map<String, dynamic> json) {
    return CompanyInfo(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      logo: json['logo'],
      owner: json['owner'] ?? '',
      isDefault: json['isDefault'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'logo': logo,
      'owner': owner,
      'isDefault': isDefault,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
