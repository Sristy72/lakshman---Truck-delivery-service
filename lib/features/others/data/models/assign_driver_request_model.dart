class AssignDriverRequestModel {
  final String driverId;

  AssignDriverRequestModel({required this.driverId});

  Map<String, dynamic> toJson() {
    return {
      'driverId': driverId,
    };
  }

  factory AssignDriverRequestModel.fromJson(Map<String, dynamic> json) {
    return AssignDriverRequestModel(
      driverId: json['driverId'] ?? '',
    );
  }
}
