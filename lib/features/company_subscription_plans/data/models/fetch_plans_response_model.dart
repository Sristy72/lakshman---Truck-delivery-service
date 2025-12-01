class FetchPlansResponseModel {
  final String id;
  final String name;
  final List<String> features;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  final double price;

  FetchPlansResponseModel({
    required this.id,
    required this.name,
    required this.features,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.price,
  });

  factory FetchPlansResponseModel.fromJson(Map<String, dynamic> json) {
    return FetchPlansResponseModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      features: (json['features'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      isActive: json['isActive'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : (json['price'] as double? ?? 0.0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'features': features,
      'isActive': isActive,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'price': price,
    };
  }
}
