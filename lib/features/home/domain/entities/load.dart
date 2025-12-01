class LoadEntity {
  final String id;
  final String title;
  final String description;
  final String category;
  final String pickupLocation;
  final String deliveryLocation;
  final String companyToken;
  final String loadBy;
  final String orderStatus;
  final DateTime? pickupDate;
  final String? note;
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
    this.pickupDate,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });
}
