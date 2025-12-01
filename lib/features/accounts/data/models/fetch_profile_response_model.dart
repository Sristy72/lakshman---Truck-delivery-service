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
  final Dashboard? dashboard;

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
    this.dashboard,
  });

  factory FetchProfileResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') ? json['data'] : json;
    final role = data['role'] ?? '';

    // Debug logging
    print('📊 Profile response for role: $role');
    print('📦 Profile data keys: ${data.keys.toList()}');

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

    // Extract data based on role
    // For driver/dispatcher, user data might be nested
    String extractString(String key, String fallback) {
      // Try direct access first
      if (data.containsKey(key)) return data[key]?.toString() ?? fallback;
      
      // For driver/dispatcher, try nested under 'user' key
      if (data.containsKey('user') && data['user'] is Map) {
        final user = data['user'] as Map<String, dynamic>;
        if (user.containsKey(key)) return user[key]?.toString() ?? fallback;
      }
      
      return fallback;
    }

    dynamic extractAvatar() {
      // Try direct access first
      if (data.containsKey('avatar')) return data['avatar'];
      
      // For driver/dispatcher, try nested under 'user' key
      if (data.containsKey('user') && data['user'] is Map) {
        final user = data['user'] as Map<String, dynamic>;
        if (user.containsKey('avatar')) return user['avatar'];
      }
      
      return null;
    }

    return FetchProfileResponseModel(
      id: extractString('_id', ''),
      name: extractString('name', ''),
      email: extractString('email', ''),
      role: role,
      address: extractString('address', ''),
      dob: extractString('dob', ''),
      nationality: extractString('nationality', ''),
      phone: extractString('phone', ''),
      stripeAccountId: extractString('stripeAccountId', ''),
      isStripeOnboarded: (data['isStripeOnboarded'] ?? false) as bool,
      passwordResetToken: extractString('password_reset_token', ''),
      createdAt: extractString('createdAt', ''),
      updatedAt: extractString('updatedAt', ''),
      avatar: parseAvatar(extractAvatar()),
      verificationInfo: VerificationInfo.fromJson(
        data.containsKey('verificationInfo')
            ? data['verificationInfo']
            : data.containsKey('user') && data['user'] is Map
                ? (data['user'] as Map<String, dynamic>)['verificationInfo'] ?? {}
                : {},
      ),
      dashboard: data.containsKey('dashboard') && data['dashboard'] is Map
          ? Dashboard.fromJson(data['dashboard'] as Map<String, dynamic>)
          : null,
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
      if (dashboard != null) "dashboard": dashboard!.toJson(),
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

class Dashboard {
  final int pendingRequests;
  final int readyToLoad;
  final int availableDrivers;

  Dashboard({
    required this.pendingRequests,
    required this.readyToLoad,
    required this.availableDrivers,
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) {
    return Dashboard(
      pendingRequests: json['pendingRequests'] ?? 0,
      readyToLoad: json['readyToLoad'] ?? 0,
      availableDrivers: json['availableDrivers'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "pendingRequests": pendingRequests,
      "readyToLoad": readyToLoad,
      "availableDrivers": availableDrivers,
    };
  }
}
