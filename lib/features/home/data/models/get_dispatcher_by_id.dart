import 'dart:convert';

DispatcherByIdResponseModel deliveryResponseModelFromJson(String str) =>
    DispatcherByIdResponseModel.fromJson(json.decode(str));

String deliveryResponseModelToJson(DispatcherByIdResponseModel data) =>
    json.encode(data.toJson());

class DispatcherByIdResponseModel {
  final String? id;
  final String? title;
  final String? description;
  final String? category;
  final String? pickupLocation;
  final String? deliveryLocation;
  final CompanyToken? companyToken;
  final LoadBy? loadBy;
  final String? orderStatus;
  final DateTime? pickupDate;
  final String? note;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  DispatcherByIdResponseModel({
    this.id,
    this.title,
    this.description,
    this.category,
    this.pickupLocation,
    this.deliveryLocation,
    this.companyToken,
    this.loadBy,
    this.orderStatus,
    this.pickupDate,
    this.note,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory DispatcherByIdResponseModel.fromJson(Map<String, dynamic> json) =>
      DispatcherByIdResponseModel(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        category: json["category"],
        pickupLocation: json["pickupLocation"],
        deliveryLocation: json["deliveryLocation"],
        companyToken: json["companyToken"] != null
            ? CompanyToken.fromJson(json["companyToken"])
            : null,
        loadBy: json["loadBy"] != null ? LoadBy.fromJson(json["loadBy"]) : null,
        orderStatus: json["orderStatus"],
        pickupDate: json["pickupDate"] != null
            ? DateTime.parse(json["pickupDate"])
            : null,
        note: json["note"],
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "description": description,
        "category": category,
        "pickupLocation": pickupLocation,
        "deliveryLocation": deliveryLocation,
        "companyToken": companyToken?.toJson(),
        "loadBy": loadBy?.toJson(),
        "orderStatus": orderStatus,
        "pickupDate": pickupDate?.toIso8601String(),
        "note": note,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class CompanyToken {
  final String? id;
  final String? name;
  final String? email;
  final String? logo;
  final String? owner;
  final bool? isDefault;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  CompanyToken({
    this.id,
    this.name,
    this.email,
    this.logo,
    this.owner,
    this.isDefault,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory CompanyToken.fromJson(Map<String, dynamic> json) => CompanyToken(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        logo: json["logo"],
        owner: json["owner"],
        isDefault: json["isDefault"],
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "logo": logo,
        "owner": owner,
        "isDefault": isDefault,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class LoadBy {
  final String? avatar;
  final VerificationInfo? verificationInfo;
  final String? id;
  final String? name;
  final String? email;
  final String? role;
  final String? stripeAccountId;
  final bool? isStripeOnboarded;
  final String? passwordResetToken;
  final String? refreshToken;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;
  final String? address;
  final String? dob;
  final String? nationality;
  final String? phone;

  LoadBy({
    this.avatar,
    this.verificationInfo,
    this.id,
    this.name,
    this.email,
    this.role,
    this.stripeAccountId,
    this.isStripeOnboarded,
    this.passwordResetToken,
    this.refreshToken,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.address,
    this.dob,
    this.nationality,
    this.phone,
  });

  factory LoadBy.fromJson(Map<String, dynamic> json) => LoadBy(
        avatar: json["avatar"],
        verificationInfo: json["verificationInfo"] != null
            ? VerificationInfo.fromJson(json["verificationInfo"])
            : null,
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        role: json["role"],
        stripeAccountId: json["stripeAccountId"],
        isStripeOnboarded: json["isStripeOnboarded"],
        passwordResetToken: json["password_reset_token"],
        refreshToken: json["refreshToken"],
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
        v: json["__v"],
        address: json["address"],
        dob: json["dob"],
        nationality: json["nationality"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "avatar": avatar,
        "verificationInfo": verificationInfo?.toJson(),
        "_id": id,
        "name": name,
        "email": email,
        "role": role,
        "stripeAccountId": stripeAccountId,
        "isStripeOnboarded": isStripeOnboarded,
        "password_reset_token": passwordResetToken,
        "refreshToken": refreshToken,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "address": address,
        "dob": dob,
        "nationality": nationality,
        "phone": phone,
      };
}

class VerificationInfo {
  final bool? verified;
  final String? token;

  VerificationInfo({
    this.verified,
    this.token,
  });

  factory VerificationInfo.fromJson(Map<String, dynamic> json) =>
      VerificationInfo(
        verified: json["verified"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "verified": verified,
        "token": token,
      };
}
