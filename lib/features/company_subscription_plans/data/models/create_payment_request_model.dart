class CreatePaymentRequestModel {
  final String userId;
  final String planId;
  final double price;
  final String type;

  CreatePaymentRequestModel({
    required this.userId,
    required this.planId,
    required this.price,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'planId': planId,
      'price': price,
      'type': type,
    };
  }
}
