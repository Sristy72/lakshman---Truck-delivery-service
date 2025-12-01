import 'dart:convert';

class AllDispatcherResponseModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String pickupLocation;
  final String deliveryLocation;
  final CompanyToken companyToken;
  final LoadBy loadBy;
  final String orderStatus;
  final DateTime pickupDate;
  final String note;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  AllDispatcherResponseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.pickupLocation,
    required this.deliveryLocation,
    required this.companyToken,
    required this.loadBy,
    required this.orderStatus,
    required this.pickupDate,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory AllDispatcherResponseModel.fromJson(Map<String, dynamic> json) {
    return AllDispatcherResponseModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      pickupLocation: json['pickupLocation'] ?? '',
      deliveryLocation: json['deliveryLocation'] ?? '',
      companyToken: CompanyToken.fromJson(json['companyToken']),
      loadBy: LoadBy.fromJson(json['loadBy']),
      orderStatus: json['orderStatus'] ?? '',
      pickupDate: DateTime.parse(json['pickupDate']),
      note: json['note'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'category': category,
      'pickupLocation': pickupLocation,
      'deliveryLocation': deliveryLocation,
      'companyToken': companyToken.toJson(),
      'loadBy': loadBy.toJson(),
      'orderStatus': orderStatus,
      'pickupDate': pickupDate.toIso8601String(),
      'note': note,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }

  static AllDispatcherResponseModel fromJsonString(String str) =>
      AllDispatcherResponseModel.fromJson(json.decode(str));

  String toJsonString() => json.encode(toJson());
}

class CompanyToken {
  final String id;
  final String name;
  final String email;
  final String? logo;
  final String owner;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  CompanyToken({
    required this.id,
    required this.name,
    required this.email,
    this.logo,
    required this.owner,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory CompanyToken.fromJson(Map<String, dynamic> json) {
    return CompanyToken(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      logo: json['logo'],
      owner: json['owner'] ?? '',
      isDefault: json['isDefault'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'] ?? 0,
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
      '__v': v,
    };
  }
}

class LoadBy {
  final Avatar avatar;
  final VerificationInfo verificationInfo;
  final String id;
  final String name;
  final String email;
  final String role;
  final String stripeAccountId;
  final bool isStripeOnboarded;
  final String passwordResetToken;
  final String refreshToken;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  LoadBy({
    required this.avatar,
    required this.verificationInfo,
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.stripeAccountId,
    required this.isStripeOnboarded,
    required this.passwordResetToken,
    required this.refreshToken,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory LoadBy.fromJson(Map<String, dynamic> json) {
    return LoadBy(
      avatar: Avatar.fromJson(json['avatar']),
      verificationInfo: VerificationInfo.fromJson(json['verificationInfo']),
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      stripeAccountId: json['stripeAccountId'] ?? '',
      isStripeOnboarded: json['isStripeOnboarded'] ?? false,
      passwordResetToken: json['password_reset_token'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'avatar': avatar.toJson(),
      'verificationInfo': verificationInfo.toJson(),
      '_id': id,
      'name': name,
      'email': email,
      'role': role,
      'stripeAccountId': stripeAccountId,
      'isStripeOnboarded': isStripeOnboarded,
      'password_reset_token': passwordResetToken,
      'refreshToken': refreshToken,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }
}

class Avatar {
  final String publicId;
  final String url;

  Avatar({required this.publicId, required this.url});

  factory Avatar.fromJson(Map<String, dynamic> json) {
    return Avatar(publicId: json['public_id'] ?? '', url: json['url'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'public_id': publicId, 'url': url};
  }
}

class VerificationInfo {
  final bool verified;
  final String token;

  VerificationInfo({required this.verified, required this.token});

  factory VerificationInfo.fromJson(Map<String, dynamic> json) {
    return VerificationInfo(
      verified: json['verified'] ?? false,
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'verified': verified, 'token': token};
  }
}
