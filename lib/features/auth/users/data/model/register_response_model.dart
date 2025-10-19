


class RegisterResponseModel {
  final String name;
  final String email;
  final String password;
  final String role;
  final String stripeAccountId;
  final bool isStripeOnboarded;
  final Avatar avatar;
  final Address address;
  final VerificationInfo verificationInfo;
  final String passwordResetToken;
  final String refreshToken;
  final String id;
  final String createdAt;
  final String updatedAt;
  final int v;
  final String accessToken;

  RegisterResponseModel({
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.stripeAccountId,
    required this.isStripeOnboarded,
    required this.avatar,
    required this.address,
    required this.verificationInfo,
    required this.passwordResetToken,
    required this.refreshToken,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.accessToken,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      password: json["password"] ?? "",
      role: json["role"] ?? "",
      stripeAccountId: json["stripeAccountId"] ?? "",
      isStripeOnboarded: json["isStripeOnboarded"] ?? false,
      avatar: Avatar.fromJson(json["avatar"] ?? {}),
      address: Address.fromJson(json["address"] ?? {}),
      verificationInfo:
          VerificationInfo.fromJson(json["verificationInfo"] ?? {}),
      passwordResetToken: json["password_reset_token"] ?? "",
      refreshToken: json["refreshToken"] ?? "",
      id: json["_id"] ?? "",
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
      v: json["__v"] ?? 0,
      accessToken: json["accessToken"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "password": password,
      "role": role,
      "stripeAccountId": stripeAccountId,
      "isStripeOnboarded": isStripeOnboarded,
      "avatar": avatar.toJson(),
      "address": address.toJson(),
      "verificationInfo": verificationInfo.toJson(),
      "password_reset_token": passwordResetToken,
      "refreshToken": refreshToken,
      "_id": id,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "__v": v,
      "accessToken": accessToken,
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
      publicId: json["public_id"] ?? "",
      url: json["url"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "public_id": publicId,
      "url": url,
    };
  }
}

class Address {
  final String street;
  final String city;
  final String state;
  final String zipCode;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      street: json["street"] ?? "",
      city: json["city"] ?? "",
      state: json["state"] ?? "",
      zipCode: json["zipCode"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "street": street,
      "city": city,
      "state": state,
      "zipCode": zipCode,
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
      verified: json["verified"] ?? false,
      token: json["token"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "verified": verified,
      "token": token,
    };
  }
}
