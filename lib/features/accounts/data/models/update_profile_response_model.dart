class UpdateProfileResponseModel {
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
  final String createdAt;
  final String updatedAt;
  final String address;
  final String dob;
  final String nationality;
  final String phone;

  UpdateProfileResponseModel({
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
    required this.address,
    required this.dob,
    required this.nationality,
    required this.phone,
  });

  factory UpdateProfileResponseModel.fromJson(Map<String, dynamic> json) {
    dynamic avatarData = json['avatar'];

    Avatar avatar;
    if (avatarData is Map<String, dynamic>) {
      avatar = Avatar.fromJson(avatarData);
    } else if (avatarData is String) {
      avatar = Avatar(publicId: '', url: avatarData);
    } else {
      avatar = Avatar(publicId: '', url: '');
    }

    return UpdateProfileResponseModel(
      avatar: avatar,
      verificationInfo: VerificationInfo.fromJson(json['verificationInfo'] ?? {}),
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      stripeAccountId: json['stripeAccountId'] ?? '',
      isStripeOnboarded: json['isStripeOnboarded'] ?? false,
      passwordResetToken: json['password_reset_token'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      address: json['address']?.toString().replaceAll('"', '').trim() ?? '',
      dob: json['dob'] ?? '',
      nationality: json['nationality'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}

class Avatar {
  final String publicId;
  final String url;

  Avatar({
    required this.publicId,
    required this.url,
  });

  factory Avatar.fromJson(Map<String, dynamic> json) {
    return Avatar(
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
