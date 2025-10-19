// class ForgotPassResponseModel {
//   final bool success;
//   final String message;
//   final dynamic data; // 👈 add this if you need to keep 'data' (optional)

//   ForgotPassResponseModel({
//     required this.success,
//     required this.message,
//     this.data,
//   });

//   factory ForgotPassResponseModel.fromJson(Map<String, dynamic> json) {
//     // Handle if 'data' is a string, null, or map
//     final dataField = json['data'];

//     return ForgotPassResponseModel(
//       success: json['success'] ?? false,
//       message: json['message'] ?? '',
//       data: (dataField is Map<String, dynamic> || dataField is List)
//           ? dataField
//           : null, // prevent 'String' from causing errors
//     );
//   }
// }


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
