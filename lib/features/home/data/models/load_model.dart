import '../../domain/entities/load_entity.dart';

class LoadModel extends LoadEntity {
  LoadModel({
    required super.id,
    required super.title,
    required super.description,
    required super.category,
    required super.pickupLocation,
    required super.deliveryLocation,
    required super.companyToken,
    required super.loadBy,
    required super.orderStatus,
    required super.pickupDate,
    required super.note,
    required super.createdAt,
    required super.updatedAt,
  });

  factory LoadModel.fromJson(Map<String, dynamic> json) {
    return LoadModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      pickupLocation: json['pickupLocation'] ?? '',
      deliveryLocation: json['deliveryLocation'] ?? '',
      companyToken: CompanyModel.fromJson(json['companyToken'] ?? {}),
      loadBy: UserModel.fromJson(json['loadBy'] ?? {}),
      orderStatus: json['orderStatus'] ?? '',
      pickupDate: json['pickupDate'] != null
          ? DateTime.parse(json['pickupDate'])
          : DateTime.now(),
      note: json['note'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
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
      'companyToken': (companyToken as CompanyModel).toJson(),
      'loadBy': (loadBy as UserModel).toJson(),
      'orderStatus': orderStatus,
      'pickupDate': pickupDate.toIso8601String(),
      'note': note,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class CompanyModel extends CompanyEntity {
  CompanyModel({
    required super.id,
    required super.name,
    required super.email,
    super.logo,
    required super.owner,
    required super.isDefault,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      logo: json['logo'],
      owner: json['owner'] ?? '',
      isDefault: json['isDefault'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
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

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.avatar,
    required super.role,
    required super.verificationInfo,
    required super.stripeAccountId,
    required super.isStripeOnboarded,
    required super.address,
    required super.dob,
    required super.nationality,
    required super.phone,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle avatar field which can be a string or an object with url field
    String? avatarUrl;
    final avatarData = json['avatar'];
    if (avatarData != null) {
      if (avatarData is String) {
        avatarUrl = avatarData;
      } else if (avatarData is Map<String, dynamic>) {
        avatarUrl = avatarData['url'] as String?;
      }
    }

    return UserModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: avatarUrl,
      role: json['role'] ?? '',
      verificationInfo: VerificationInfoModel.fromJson(
        json['verificationInfo'] ?? {},
      ),
      stripeAccountId: json['stripeAccountId'] ?? '',
      isStripeOnboarded: json['isStripeOnboarded'] ?? false,
      address: json['address'] ?? '',
      dob: json['dob'] ?? '',
      nationality: json['nationality'] ?? '',
      phone: json['phone'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'role': role,
      'verificationInfo': (verificationInfo as VerificationInfoModel).toJson(),
      'stripeAccountId': stripeAccountId,
      'isStripeOnboarded': isStripeOnboarded,
      'address': address,
      'dob': dob,
      'nationality': nationality,
      'phone': phone,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class VerificationInfoModel extends VerificationInfoEntity {
  VerificationInfoModel({required super.verified, required super.token});

  factory VerificationInfoModel.fromJson(Map<String, dynamic> json) {
    return VerificationInfoModel(
      verified: json['verified'] ?? false,
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'verified': verified, 'token': token};
  }
}
