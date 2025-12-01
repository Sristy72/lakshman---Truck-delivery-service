class Dispatcher {
  final String id;
  final String name;
  final String mobile;
  final String? email;
  final String? imageUrl;

  Dispatcher({
    required this.id,
    required this.name,
    required this.mobile,
    this.email,
    this.imageUrl,
  });

  factory Dispatcher.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    
    return Dispatcher(
      id: json['_id'] ?? '',
      name: user?['name'] ?? 'Unknown',
      mobile: user?['phone'] ?? 'N/A',
      email: user?['email'],
      imageUrl: user?['avatar']?['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': {
        'name': name,
        'phone': mobile,
        'email': email,
        'avatar': {
          'url': imageUrl,
        }
      },
    };
  }
}

List<Dispatcher> parseDispatchersFromJson(List<dynamic> jsonList) {
  return jsonList.map((json) => Dispatcher.fromJson(json)).toList();
}