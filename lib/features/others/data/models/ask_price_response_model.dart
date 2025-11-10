class AskPriceResponseModel {
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
  final int v;
  final double askPrice;

  AskPriceResponseModel({
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
    required this.askPrice,
  });

  factory AskPriceResponseModel.fromJson(Map<String, dynamic> json) {
    return AskPriceResponseModel(
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
      v: json['__v'] ?? 0,
      askPrice: (json['askPrice'] is int) 
          ? (json['askPrice'] as int).toDouble() 
          : (json['askPrice'] ?? 0.0).toDouble(),
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
      'pickupDate': pickupDate,
      'note': note,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'askPrice': askPrice,
    };
  }
}
