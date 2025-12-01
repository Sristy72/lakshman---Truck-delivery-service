class CreateOrderPaymentRequestModel {
  final String loadId;
  final String planId;
  final double price;
  final String type;

  CreateOrderPaymentRequestModel({
    required this.loadId,
    required this.planId,
    required this.price,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'loadId': loadId,
      'planId': planId,
      'price': price,
      'type': type,
    };
  }
}
