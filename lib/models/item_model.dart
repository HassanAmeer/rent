/// Item/Product Model for listings and items
import 'dart:convert';
import 'user_model.dart';

class ItemModel {
  final int id;
  final int userId;
  final String title;
  final String? description;
  final String? categoryName;
  final double dailyRate;
  final double weeklyRate;
  final double monthlyRate;
  final String? availabilityDays;
  final String? availabilityRange;
  final List<String> images;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserModel? user; // Owner of the item

  ItemModel({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    this.categoryName,
    required this.dailyRate,
    required this.weeklyRate,
    required this.monthlyRate,
    this.availabilityDays,
    this.availabilityRange,
    required this.images,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    List<String> parseImages(dynamic imagesData) {
      if (imagesData == null) return [];
      if (imagesData is List) {
        return imagesData.map((img) => img?.toString() ?? '').toList();
      }
      if (imagesData is String) {
        try {
          final decoded = jsonDecode(imagesData);
          if (decoded is List) {
            return decoded.map((img) => img?.toString() ?? '').toList();
          }
        } catch (_) {}
        return [imagesData];
      }
      return [];
    }

    return ItemModel(
      id: json['id'] ?? 0,
      userId: json['userId'] ?? json['user_id'] ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      categoryName:
          json['categoryName']?.toString() ?? json['catgname']?.toString(),
      dailyRate:
          double.tryParse(
            json['dailyRate']?.toString() ??
                json['dailyrate']?.toString() ??
                '0',
          ) ??
          0.0,
      weeklyRate:
          double.tryParse(
            json['weeklyRate']?.toString() ??
                json['weeklyrate']?.toString() ??
                '0',
          ) ??
          0.0,
      monthlyRate:
          double.tryParse(
            json['monthlyRate']?.toString() ??
                json['monthlyrate']?.toString() ??
                '0',
          ) ??
          0.0,
      availabilityDays: json['availabilityDays']?.toString(),
      availabilityRange:
          json['availabilityRange']?.toString() ??
          json['availabilityrange']?.toString(),
      images: parseImages(json['images']),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'categoryName': categoryName,
      'dailyRate': dailyRate,
      'weeklyRate': weeklyRate,
      'monthlyRate': monthlyRate,
      'availabilityDays': availabilityDays,
      'availabilityRange': availabilityRange,
      'images': images,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'user': user?.toJson(),
    };
  }

  /// Get primary image URL
  String get primaryImageUrl {
    if (images.isEmpty) return '';
    return 'https://thelocalrent.com/uploads/${images.first}';
  }

  /// Get all image URLs
  List<String> get imageUrls {
    return images
        .map((img) => 'https://thelocalrent.com/uploads/$img')
        .toList();
  }

  /// Check if item has images
  bool get hasImages => images.isNotEmpty;

  /// Get formatted price for display
  String get formattedDailyRate => '\$${dailyRate.toStringAsFixed(2)}';
  String get formattedWeeklyRate => '\$${weeklyRate.toStringAsFixed(2)}';
  String get formattedMonthlyRate => '\$${monthlyRate.toStringAsFixed(2)}';

  /// Get display title with fallback
  String get displayTitle => title.isNotEmpty ? title : 'Untitled Item';

  /// Get short description for previews
  String get shortDescription {
    if (description == null || description!.isEmpty) return '';
    return description!.length > 100
        ? '${description!.substring(0, 100)}...'
        : description!;
  }

  /// Check if item is available
  bool get isAvailable =>
      availabilityDays != null && availabilityDays!.isNotEmpty;

  @override
  String toString() {
    return 'ItemModel(id: $id, title: $title, dailyRate: $dailyRate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ItemModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
