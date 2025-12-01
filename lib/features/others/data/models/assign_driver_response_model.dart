class AssignDriverResponseModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String pickupLocation;
  final String deliveryLocation;
  final String companyToken;
  final String loadBy;
  final String orderStatus;
  final DateTime pickupDate;
  final String note;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;
  final double? askPrice;
  final String? driver;

  AssignDriverResponseModel({
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
    required this.v,
    this.askPrice,
    this.driver,
  });

  factory AssignDriverResponseModel.fromJson(Map<String, dynamic> json) {
    return AssignDriverResponseModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      pickupLocation: json['pickupLocation'] ?? '',
      deliveryLocation: json['deliveryLocation'] ?? '',
      companyToken: json['companyToken'] ?? '',
      loadBy: json['loadBy'] ?? '',
      orderStatus: json['orderStatus'] ?? '',
      pickupDate: json['pickupDate'] != null
          ? DateTime.parse(json['pickupDate'])
          : DateTime.now(),
      note: json['note'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      v: json['__v'] ?? 0,
      askPrice: json['askPrice'] != null ? (json['askPrice'] as num).toDouble() : null,
      driver: json['driver'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'category': category,
      'pickupLocation': pickupLocation,
      'deliveryLocation': deliveryLocation,
      'companyToken': companyToken,
      'loadBy': loadBy,
      'orderStatus': orderStatus,
      'pickupDate': pickupDate.toIso8601String(),
      'note': note,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
      if (askPrice != null) 'askPrice': askPrice,
      if (driver != null) 'driver': driver,
    };
  }
}
