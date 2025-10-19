// class RegisterRequestModel {
//   final String name;
//   final String email;
//   final String password;
//   // final String phone;
//   // final String username;
//   final String confirmPassword;
//   final String role;

//   RegisterRequestModel({
//     required this.name,
//     required this.email,
//     required this.password,
//     // required this.phone,
//     // required this.username,
//     required this.confirmPassword,
//     required this.role,
//   });

//   /// Convert to JSON for API request
//   Map<String, dynamic> toJson() {
//     return {
//       "name": name,
//       "email": email,
//       "password": password,
//       // "phone": phone,
//       // "username": username,
//       "confirmPassword": confirmPassword,
//       "role": role,
//     };
//   }

//   /// Optional: create from JSON (if needed for response parsing)
//   factory RegisterRequestModel.fromJson(Map<String, dynamic> json) {
//     return RegisterRequestModel(
//       name: json["name"] ?? "",
//       email: json["email"] ?? "",
//       password: json["password"] ?? "",
//       // phone: json["phone"] ?? "",
//       // username: json["username"] ?? "",
//       confirmPassword: json["confirmPassword"] ?? "",
//       role: json["role"] ?? "",
//     );
//   }
// }


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
