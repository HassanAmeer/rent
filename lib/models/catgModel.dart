import 'package:rent/constants/api_endpoints.dart';
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
      id: json['id'] ?? 1,
      image: json['image'] != null && json['image'].toString().trim().isNotEmpty
          ? Api.imgPath + json['image'].toString()
          : Api.imgPath + 'demo-category.png',
      name: (json['name']?.toString() ?? '').toNullStringOrDemo(
        'Demo Category',
      ),
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CategoryModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
