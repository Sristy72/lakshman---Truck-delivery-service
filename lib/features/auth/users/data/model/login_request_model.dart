// class LoginRequestModel {
//   final String email;
//   final String password;
//   // final String role;

//   LoginRequestModel({
//     required this.email,
//     required this.password,
//     // required this.role,
//   });

//   // Convert model to JSON (for sending in API request)
//   Map<String, dynamic> toJson() {
//     return {
//       "email": email,
//       "password": password,
//       // "role": role,
//     };
//   }

//   // Create model from JSON (optional, if you need to read it back)
//   factory LoginRequestModel.fromJson(Map<String, dynamic> json) {
//     return LoginRequestModel(
//       email: json["email"],
//       password: json["password"],
//       // role: json["role"],
//     );
//   }
// }


class LoginRequestModel {
  final String email;
  final String password;

  LoginRequestModel({
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "password": password,
    };
  }
}

