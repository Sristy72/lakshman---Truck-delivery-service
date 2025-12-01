import 'package:dio/dio.dart';

class CreateDriverRequest {
  final String name;
  final String email;
  final String password;
  final String phone;
  final String company;

  CreateDriverRequest({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.company,
  });

  Map<String, String> toMap() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
      'company': company,
    };
  }

  FormData toFormData() {
    final formData = FormData();
    formData.fields.addAll([
      MapEntry('name', name),
      MapEntry('email', email),
      MapEntry('password', password),
      MapEntry('phone', phone),
      MapEntry('company', company),
    ]);
    return formData;
  }
}
