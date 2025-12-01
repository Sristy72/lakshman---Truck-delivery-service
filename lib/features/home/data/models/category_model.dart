class CategoryImage {
  final String publicId;
  final String url;

  CategoryImage({
    required this.publicId,
    required this.url,
  });

  factory CategoryImage.fromJson(Map<String, dynamic> json) {
    return CategoryImage(
      publicId: json['public_id'] ?? '',
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'public_id': publicId,
      'url': url,
    };
  }

  @override
  String toString() => 'CategoryImage(publicId: $publicId, url: $url)';
}

class CategoryModel {
  final String id;
  final String name;
  final CategoryImage image;
  final DateTime createdAt;
  final DateTime updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      image: CategoryImage.fromJson(json['image'] ?? {}),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'image': image.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() => 'CategoryModel(id: $id, name: $name)';
}