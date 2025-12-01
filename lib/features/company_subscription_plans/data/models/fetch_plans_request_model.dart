class FetchPlansRequestModel {
  final String email;

  FetchPlansRequestModel({required this.email});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}
