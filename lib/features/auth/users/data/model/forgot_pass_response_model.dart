class ForgotPassResponseModel {
  final bool success;
  final String message;

  ForgotPassResponseModel({
    required this.success,
    required this.message,
  });

  factory ForgotPassResponseModel.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return ForgotPassResponseModel(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
      );
    } else {
      // if API client accidentally passes a String or null
      return ForgotPassResponseModel(success: false, message: '');
    }
  }
}
