class Dispatcher {
  final int id;
  final String name;
  final String mobile;
  final String? imageUrl;

  Dispatcher({
    required this.id,
    required this.name,
    required this.mobile,
    this.imageUrl,
  });

  factory Dispatcher.fromJson(Map<String, dynamic> json) {
    return Dispatcher(
      id: json['id'],
      name: json['name'],
      mobile: json['mobile'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'mobile': mobile,
      'imageUrl': imageUrl,
    };
  }
}

List<Dispatcher> parseDispatchersFromJson(List<dynamic> jsonList) {
  return jsonList.map((json) => Dispatcher.fromJson(json)).toList();
}