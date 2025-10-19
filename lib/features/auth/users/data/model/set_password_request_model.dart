class ResetPasswordRequestModel {
  final String email;
  final String otp;
  final String password;

  ResetPasswordRequestModel({
    required this.email,
    required this.otp,
    required this.password,
  });

  // Convert Dart object → JSON
  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "otp": otp,
      "password": password,
    };
  }

  // Optional: Convert JSON → Dart object (if needed)
  
}
