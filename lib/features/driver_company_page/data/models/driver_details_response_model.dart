class DriverDetailsResponseModel {
  final String id;
  final UserData user;
  final dynamic drivingLicense;
  final CompanyData company;
  final DateTime createdAt;
  final DateTime updatedAt;

  DriverDetailsResponseModel({
    required this.id,
    required this.user,
    this.drivingLicense,
    required this.company,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DriverDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return DriverDetailsResponseModel(
      id: json['_id'] ?? '',
      user: UserData.fromJson(json['user'] as Map<String, dynamic>? ?? {}),
      drivingLicense: json['drivingLicense'],
      company: CompanyData.fromJson(json['company'] as Map<String, dynamic>? ?? {}),
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'user': user.toJson(),
    'drivingLicense': drivingLicense,
    'company': company.toJson(),
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}

class UserData {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final AvatarData? avatar;
  final bool verified;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.avatar,
    this.verified = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      avatar: json['avatar'] != null ? AvatarData.fromJson(json['avatar'] as Map<String, dynamic>) : null,
      verified: (json['verificationInfo'] as Map<String, dynamic>?)?['verified'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'role': role,
    'avatar': avatar?.toJson(),
    'verificationInfo': {'verified': verified},
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}

class AvatarData {
  final String? url;
  final String? publicId;

  AvatarData({
    this.url,
    this.publicId,
  });

  factory AvatarData.fromJson(Map<String, dynamic> json) {
    return AvatarData(
      url: json['url'] as String?,
      publicId: json['public_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'url': url,
    'public_id': publicId,
  };
}

class CompanyData {
  final String id;
  final String name;
  final String email;
  final String? logo;

  CompanyData({
    required this.id,
    required this.name,
    required this.email,
    this.logo,
  });

  factory CompanyData.fromJson(Map<String, dynamic> json) {
    return CompanyData(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      logo: json['logo'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'email': email,
    'logo': logo,
  };
}
