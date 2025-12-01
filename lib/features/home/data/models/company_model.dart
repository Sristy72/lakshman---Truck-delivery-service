class CompanyModel {
  final String id;
  final String name;
  final String email;
  final String? logo;
  final String owner;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? information;
  final String? uniqueCode;

  CompanyModel({
    required this.id,
    required this.name,
    required this.email,
    this.logo,
    required this.owner,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
    this.information,
    this.uniqueCode,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      logo: json['logo'],
      owner: json['owner'] ?? '',
      isDefault: json['isDefault'] ?? false,
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      information: json['information'],
      uniqueCode: json['uniqueCode'],
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
      'information': information,
      'uniqueCode': uniqueCode,
    };
  }

  @override
  String toString() => 'CompanyModel(id: $id, name: $name, email: $email)';
}