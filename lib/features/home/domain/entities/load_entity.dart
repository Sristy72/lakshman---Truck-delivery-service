class LoadEntity {
  final String id;
  final String title;
  final String description;
  final String category;
  final String pickupLocation;
  final String deliveryLocation;
  final CompanyEntity companyToken;
  final UserEntity loadBy;
  final String orderStatus;
  final DateTime pickupDate;
  final String note;
  final DateTime createdAt;
  final DateTime updatedAt;

  LoadEntity({
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
  });
}

class CompanyEntity {
  final String id;
  final String name;
  final String email;
  final String? logo;
  final String owner;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  CompanyEntity({
    required this.id,
    required this.name,
    required this.email,
    this.logo,
    required this.owner,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });
}

class UserEntity {
  final String id;
  final String name;
  final String email;
  final String? avatar;
  final String role;
  final VerificationInfoEntity verificationInfo;
  final String stripeAccountId;
  final bool isStripeOnboarded;
  final String address;
  final String dob;
  final String nationality;
  final String phone;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.avatar,
    required this.role,
    required this.verificationInfo,
    required this.stripeAccountId,
    required this.isStripeOnboarded,
    required this.address,
    required this.dob,
    required this.nationality,
    required this.phone,
    required this.createdAt,
    required this.updatedAt,
  });
}

class VerificationInfoEntity {
  final bool verified;
  final String token;

  VerificationInfoEntity({required this.verified, required this.token});
}
