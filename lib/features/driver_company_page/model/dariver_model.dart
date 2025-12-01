class Driver {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? imageUrl;
  final String? address;
  final String? dateOfBirth;
  final String? nationality;
  final int deliveryCount;
  final double rating;

  Driver({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.imageUrl,
    this.address,
    this.dateOfBirth,
    this.nationality,
    this.deliveryCount = 0,
    this.rating = 0.0,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    
    return Driver(
      id: json['_id'] ?? '',
      name: user?['name'] ?? 'Unknown',
      phone: user?['phone'] ?? 'N/A',
      email: user?['email'],
      imageUrl: user?['avatar']?['url'],
      address: user?['address'],
      dateOfBirth: user?['dateOfBirth'],
      nationality: user?['nationality'],
      deliveryCount: json['deliveryCount'] ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': {
        'name': name,
        'phone': phone,
        'email': email,
        'address': address,
        'dateOfBirth': dateOfBirth,
        'nationality': nationality,
        'avatar': {
          'url': imageUrl,
        }
      },
      'deliveryCount': deliveryCount,
      'rating': rating,
    };
  }
}

List<Driver> parseDriversFromJson(List<dynamic> jsonList) {
  return jsonList.map((json) => Driver.fromJson(json)).toList();
}