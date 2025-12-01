class CreateDriverResponse {
  final String user;
  final String? drivingLicense;
  final String company;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  CreateDriverResponse({
    required this.user,
    this.drivingLicense,
    required this.company,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CreateDriverResponse.fromJson(Map<String, dynamic> json) {
    return CreateDriverResponse(
      user: json['user'] ?? '',
      drivingLicense: json['drivingLicense'],
      company: json['company'] ?? '',
      id: json['_id'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'drivingLicense': drivingLicense,
      'company': company,
      '_id': id,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
