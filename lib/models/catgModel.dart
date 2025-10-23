import 'package:rent/constants/tostring.dart';

/// Category Model for item categories
class CategoryModel {
  final int id;
  final String image;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CategoryModel({
    required this.id,
    required this.image,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      image: json['image'].toString().toNullString(),
      name: json['name'].toString().toNullString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'name': name,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Get full image URL
  String get fullImageUrl {
    if (image.isEmpty) return '';
    // Assuming 'images/' is a prefix for local assets or a base path for remote images
    // Adjust this logic based on how your images are stored and served
    if (image.startsWith('http://') || image.startsWith('https://')) {
      return image;
    }
    return 'https://thelocalrent.com/uploads/$image'; // Example for remote images
  }

  @override
  String toString() {
    return 'CategoryModel(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
