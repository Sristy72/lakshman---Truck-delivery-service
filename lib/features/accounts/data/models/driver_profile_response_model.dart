class DriverProfileResponseModel {
  final String id;
  final DriverUser user;
  final dynamic drivingLicense;
  final dynamic company;
  final String createdAt;
  final String updatedAt;
  final DriverDashboard? dashboard;

  DriverProfileResponseModel({
    required this.id,
    required this.user,
    this.drivingLicense,
    this.company,
    required this.createdAt,
    required this.updatedAt,
    this.dashboard,
  });

  factory DriverProfileResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') ? json['data'] : json;
    
    print('📊 Driver Profile Response:');
    print('📦 Keys: ${data.keys.toList()}');
    
    return DriverProfileResponseModel(
      id: data['_id'] ?? '',
      user: DriverUser.fromJson(data['user'] as Map<String, dynamic>? ?? {}),
      drivingLicense: data['drivingLicense'],
      company: data['company'],
      createdAt: data['createdAt'] ?? '',
      updatedAt: data['updatedAt'] ?? '',
      dashboard: data.containsKey('dashboard') && data['dashboard'] is Map
          ? DriverDashboard.fromJson(data['dashboard'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "user": user.toJson(),
      "drivingLicense": drivingLicense,
      "company": company,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      if (dashboard != null) "dashboard": dashboard!.toJson(),
    };
  }
}

class DriverUser {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String stripeAccountId;
  final bool isStripeOnboarded;
  final String passwordResetToken;
  final String createdAt;
  final String updatedAt;
  final DriverAvatar avatar;
  final DriverVerificationInfo verificationInfo;

  DriverUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.stripeAccountId,
    required this.isStripeOnboarded,
    required this.passwordResetToken,
    required this.createdAt,
    required this.updatedAt,
    required this.avatar,
    required this.verificationInfo,
  });

  factory DriverUser.fromJson(Map<String, dynamic> json) {
    return DriverUser(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
      stripeAccountId: json['stripeAccountId'] ?? '',
      isStripeOnboarded: json['isStripeOnboarded'] ?? false,
      passwordResetToken: json['password_reset_token'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      avatar: DriverAvatar.fromJson(json['avatar'] as Map<String, dynamic>? ?? {}),
      verificationInfo: DriverVerificationInfo.fromJson(
        json['verificationInfo'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "email": email,
      "phone": phone,
      "role": role,
      "stripeAccountId": stripeAccountId,
      "isStripeOnboarded": isStripeOnboarded,
      "password_reset_token": passwordResetToken,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "avatar": avatar.toJson(),
      "verificationInfo": verificationInfo.toJson(),
    };
  }
}

class DriverAvatar {
  final String publicId;
  final String url;

  DriverAvatar({
    required this.publicId,
    required this.url,
  });

  factory DriverAvatar.fromJson(Map<String, dynamic> json) {
    return DriverAvatar(
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

class DriverVerificationInfo {
  final bool verified;
  final String token;

  DriverVerificationInfo({
    required this.verified,
    required this.token,
  });

  factory DriverVerificationInfo.fromJson(Map<String, dynamic> json) {
    return DriverVerificationInfo(
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

class DriverDashboard {
  final int totalAssigned;
  final CurrentLoad? currentLoad;
  final List<RecentLoad> recentLoads;

  DriverDashboard({
    required this.totalAssigned,
    this.currentLoad,
    required this.recentLoads,
  });

  factory DriverDashboard.fromJson(Map<String, dynamic> json) {
    print('📊 Dashboard Data: ${json.keys.toList()}');
    
    return DriverDashboard(
      totalAssigned: json['totalAssigned'] ?? 0,
      currentLoad: json['currentLoad'] != null && json['currentLoad'] is Map
          ? CurrentLoad.fromJson(json['currentLoad'] as Map<String, dynamic>)
          : null,
      recentLoads: json['recentLoads'] != null && json['recentLoads'] is List
          ? (json['recentLoads'] as List)
              .map((item) => RecentLoad.fromJson(item as Map<String, dynamic>))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "totalAssigned": totalAssigned,
      if (currentLoad != null) "currentLoad": currentLoad!.toJson(),
      "recentLoads": recentLoads.map((item) => item.toJson()).toList(),
    };
  }
}

class CurrentLoad {
  final String id;
  final String title;
  final String description;
  final String category;
  final String pickupLocation;
  final String deliveryLocation;
  final String companyToken;
  final String loadBy;
  final String orderStatus;
  final String pickupDate;
  final String note;
  final String createdAt;
  final String updatedAt;
  final int? askPrice;
  final String? driver;

  CurrentLoad({
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
    this.askPrice,
    this.driver,
  });

  factory CurrentLoad.fromJson(Map<String, dynamic> json) {
    return CurrentLoad(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      pickupLocation: json['pickupLocation'] ?? '',
      deliveryLocation: json['deliveryLocation'] ?? '',
      companyToken: json['companyToken'] ?? '',
      loadBy: json['loadBy'] ?? '',
      orderStatus: json['orderStatus'] ?? '',
      pickupDate: json['pickupDate'] ?? '',
      note: json['note'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      askPrice: json['askPrice'],
      driver: json['driver'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "title": title,
      "description": description,
      "category": category,
      "pickupLocation": pickupLocation,
      "deliveryLocation": deliveryLocation,
      "companyToken": companyToken,
      "loadBy": loadBy,
      "orderStatus": orderStatus,
      "pickupDate": pickupDate,
      "note": note,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      if (askPrice != null) "askPrice": askPrice,
      if (driver != null) "driver": driver,
    };
  }
}

class RecentLoad {
  final String id;
  final String title;
  final String description;
  final String category;
  final String pickupLocation;
  final String deliveryLocation;
  final String companyToken;
  final String loadBy;
  final String orderStatus;
  final String pickupDate;
  final String note;
  final String createdAt;
  final String updatedAt;
  final int? askPrice;
  final String? driver;

  RecentLoad({
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
    this.askPrice,
    this.driver,
  });

  factory RecentLoad.fromJson(Map<String, dynamic> json) {
    return RecentLoad(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      pickupLocation: json['pickupLocation'] ?? '',
      deliveryLocation: json['deliveryLocation'] ?? '',
      companyToken: json['companyToken'] ?? '',
      loadBy: json['loadBy'] ?? '',
      orderStatus: json['orderStatus'] ?? '',
      pickupDate: json['pickupDate'] ?? '',
      note: json['note'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      askPrice: json['askPrice'],
      driver: json['driver'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "title": title,
      "description": description,
      "category": category,
      "pickupLocation": pickupLocation,
      "deliveryLocation": deliveryLocation,
      "companyToken": companyToken,
      "loadBy": loadBy,
      "orderStatus": orderStatus,
      "pickupDate": pickupDate,
      "note": note,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      if (askPrice != null) "askPrice": askPrice,
      if (driver != null) "driver": driver,
    };
  }
}
