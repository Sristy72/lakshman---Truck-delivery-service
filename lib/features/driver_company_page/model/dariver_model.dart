class Driver {
  final int id;
  final String name;
  final int deliveryCount;
  final double rating;
  final String imageUrl;
  final String status; // "available" or "on_load"

  Driver({
    required this.id,
    required this.name,
    required this.deliveryCount,
    required this.rating,
    required this.imageUrl,
    required this.status,
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id'],
      name: json['name'],
      deliveryCount: json['deliveryCount'],
      rating: json['rating'].toDouble(),
      imageUrl: json['imageUrl'] ?? "assets/images/truck_home.png",
      status: json['status'],
    );
  }

  // Method to convert Driver to JSON (for API requests)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'deliveryCount': deliveryCount,
      'rating': rating,
      'imageUrl': imageUrl,
      'status': status,
    };
  }
}

// Helper method to parse list of drivers from API response
List<Driver> parseDriversFromJson(List<dynamic> jsonList) {
  return jsonList.map((json) => Driver.fromJson(json)).toList();
}