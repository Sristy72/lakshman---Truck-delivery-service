class RegisterRequestModel {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final String role;

  RegisterRequestModel({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.role,
  });

  // Convert model to JSON (for sending to API)
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email,
      "password": password,
      "confirmPassword": confirmPassword,
      "role": role,
    };
  }
}
