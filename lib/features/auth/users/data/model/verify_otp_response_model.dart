class VerifyMailOtpResponseModel {
  final bool success;
  final String message;


  VerifyMailOtpResponseModel({
    required this.success,
    required this.message,
  });

  factory VerifyMailOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyMailOtpResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
