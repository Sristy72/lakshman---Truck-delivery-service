class FetchProfileResponseModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String address;
  final String dob;
  final String nationality;
  final String phone;
  final String stripeAccountId;
  final bool isStripeOnboarded;
  final String passwordResetToken;
  final String createdAt;
  final String updatedAt;
  final Avatar avatar;
  final VerificationInfo verificationInfo;

  FetchProfileResponseModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.address,
    required this.dob,
    required this.nationality,
    required this.phone,
    required this.stripeAccountId,
    required this.isStripeOnboarded,
    required this.passwordResetToken,
    required this.createdAt,
    required this.updatedAt,
    required this.avatar,
    required this.verificationInfo,
  });

  factory FetchProfileResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') ? json['data'] : json;

    // Handle avatar being either a String or Map
    Avatar parseAvatar(dynamic avatar) {
      if (avatar is String) {
        return Avatar(publicId: '', url: avatar);
      } else if (avatar is Map<String, dynamic>) {
        return Avatar.fromJson(avatar);
      } else {
        return Avatar(publicId: '', url: '');
      }
    }

    return FetchProfileResponseModel(
      id: data['_id'] ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: data['role'] ?? '',
      address: data['address'] ?? '',
      dob: data['dob'] ?? '',
      nationality: data['nationality'] ?? '',
      phone: data['phone'] ?? '',
      stripeAccountId: data['stripeAccountId'] ?? '',
      isStripeOnboarded: data['isStripeOnboarded'] ?? false,
      passwordResetToken: data['password_reset_token'] ?? '',
      createdAt: data['createdAt'] ?? '',
      updatedAt: data['updatedAt'] ?? '',
      avatar: parseAvatar(data['avatar']),
      verificationInfo: VerificationInfo.fromJson(data['verificationInfo'] ?? {}),
    );
  }



  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "email": email,
      "role": role,
      "stripeAccountId": stripeAccountId,
      "isStripeOnboarded": isStripeOnboarded,
      "password_reset_token": passwordResetToken,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      'avatar': avatar.toJson(),
      'address': address,
      'dob': dob,
      'nationality': nationality,
      'phone': phone,
      "verificationInfo": verificationInfo.toJson(),
    };
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
      "public_id": publicId,
      "url": url,
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
      "verified": verified,
      "token": token,
    };
  }
}
