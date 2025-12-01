class GeocodingAddressModel {
  final String formattedAddress;
  final String placeId;

  GeocodingAddressModel({required this.formattedAddress, this.placeId = ''});

  factory GeocodingAddressModel.fromJson(Map<String, dynamic> json) {
    return GeocodingAddressModel(
      formattedAddress: json['formatted_address'] as String? ?? '',
      placeId: json['place_id'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'formatted_address': formattedAddress,
    'place_id': placeId,
  };
}
