class AuthResponseModel {
  final String accessToken;
  final String refreshToken;
  final String role;
  final String id;
  final User user;

  AuthResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.role,
    required this.id,
    required this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json["accessToken"] ?? "",
      refreshToken: json["refreshToken"] ?? "",
      role: json["role"] ?? "",
      id: json["_id"] ?? "",
      user: User.fromJson(json["user"] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "accessToken": accessToken,
      "refreshToken": refreshToken,
      "role": role,
      "_id": id,
      "user": user.toJson(),
    };
  }
}

class User {
  final Avatar avatar;
  final Address address;
  final VerificationInfo verificationInfo;
  final String id;
  final String name;
  final String email;
  final String password;
  final String role;
  final String stripeAccountId;
  final bool isStripeOnboarded;
  final String passwordResetToken;
  final String refreshToken;
  final String createdAt;
  final String updatedAt;
  final int v;

  User({
    required this.avatar,
    required this.address,
    required this.verificationInfo,
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
    required this.stripeAccountId,
    required this.isStripeOnboarded,
    required this.passwordResetToken,
    required this.refreshToken,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      avatar: Avatar.fromJson(json["avatar"]),
      address: Address.fromJson(json["address"]),
      verificationInfo: VerificationInfo.fromJson(json["verificationInfo"] ?? {}),
      id: json["_id"] ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      password: json["password"] ?? "",
      role: json["role"] ?? "",
      stripeAccountId: json["stripeAccountId"] ?? "",
      isStripeOnboarded: json["isStripeOnboarded"] ?? false,
      passwordResetToken: json["password_reset_token"] ?? "",
      refreshToken: json["refreshToken"] ?? "",
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
      v: json["__v"] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "avatar": avatar.toJson(),
      "address": address.toJson(),
      "verificationInfo": verificationInfo.toJson(),
      "_id": id,
      "name": name,
      "email": email,
      "password": password,
      "role": role,
      "stripeAccountId": stripeAccountId,
      "isStripeOnboarded": isStripeOnboarded,
      "password_reset_token": passwordResetToken,
      "refreshToken": refreshToken,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "__v": v,
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

  factory Avatar.fromJson(dynamic json) {
    // Handle null
    if (json == null) return Avatar(publicId: '', url: '');
    
    // Handle if avatar is a String (direct URL)
    if (json is String) {
      return Avatar(publicId: '', url: json);
    }
    
    // Handle if avatar is a Map (object with url and public_id)
    if (json is Map<String, dynamic>) {
      return Avatar(
        publicId: json["public_id"] ?? "",
        url: json["url"] ?? "",
      );
    }
    
    // Fallback for unexpected format
    return Avatar(publicId: '', url: '');
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

  factory Address.fromJson(dynamic json) {
    // Handle null
    if (json == null) return Address(street: '', city: '', state: '', zipCode: '');
    
    // Handle if address is a String (direct address or single field)
    if (json is String) {
      return Address(street: json, city: '', state: '', zipCode: '');
    }
    
    // Handle if address is a Map (object with street, city, state, zipCode)
    if (json is Map<String, dynamic>) {
      return Address(
        street: json["street"] ?? "",
        city: json["city"] ?? "",
        state: json["state"] ?? "",
        zipCode: json["zipCode"] ?? "",
      );
    }
    
    // Fallback for unexpected format
    return Address(street: '', city: '', state: '', zipCode: '');
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
