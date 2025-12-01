class CreatePaymentResponseModel {
  final String clientSecret;

  CreatePaymentResponseModel({
    required this.clientSecret,
  });

  factory CreatePaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return CreatePaymentResponseModel(
      clientSecret: json['clientSecret'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'clientSecret': clientSecret,
    };
  }
}
