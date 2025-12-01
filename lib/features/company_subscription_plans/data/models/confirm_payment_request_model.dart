class ConfirmPaymentRequestModel {
  final String paymentIntentId;

  ConfirmPaymentRequestModel({
    required this.paymentIntentId,
  });

  Map<String, dynamic> toJson() {
    return {
      'paymentIntentId': paymentIntentId,
    };
  }
}
