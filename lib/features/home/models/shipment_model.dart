
class Shipment {
  final String id;
  final String title;
  final String description;
  final String origin;
  final String destination;
  final String? status; // Optional field for future use

  Shipment({
    required this.id,
    required this.title,
    required this.description,
    required this.origin,
    required this.destination,
    this.status,
  });

  // // <-- for API integration -->
  // factory Shipment.fromJson(Map<String, dynamic> json) {
  //   return Shipment(
  //     id: json['id'] ?? '',
  //     title: json['title'] ?? '',
  //     description: json['description'] ?? '',
  //     origin: json['origin'] ?? '',
  //     destination: json['destination'] ?? '',
  //     status: json['status'],
  //   );
  // }
}
