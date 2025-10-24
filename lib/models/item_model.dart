/// Item/Product Model for listings and items
library;

import 'dart:convert';
import 'package:rent/constants/api_endpoints.dart';

import '../constants/images.dart';
import 'user_model.dart';

class ItemModel {
  final int id;
  final int userId;
  final String title;
  final String? description;
  final int? categoryId;
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
    this.id = 0,
    this.userId = 0,
    this.title = "",
    this.description,
    this.categoryId,
    this.dailyRate = 0.0,
    this.weeklyRate = 0.0,
    this.monthlyRate = 0.0,
    this.availabilityDays,
    this.availabilityRange,
    this.images = const [],
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    List<String> parseImages(dynamic imagesData) {
      if (imagesData == null) return [];
      if (imagesData is List) {
        return imagesData.map((img) => Api.imgPath + img).toList();
      }
      if (imagesData is String) {
        try {
          final decoded = jsonDecode(imagesData);
          if (decoded is List) {
            return decoded.map((img) => Api.imgPath + img).toList();
          }
        } catch (_) {}
        return [imagesData];
      }
      return [];
    }

    return ItemModel(
      id: json['id'] ?? 0,
      userId: json['productBy'] ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      categoryId: int.tryParse(json['category']?.toString() ?? '0'),
      dailyRate: double.tryParse(json['dailyrate']?.toString() ?? '0') ?? 0.0,
      weeklyRate: double.tryParse(json['weeklyrate']?.toString() ?? '0') ?? 0.0,
      monthlyRate:
          double.tryParse(json['monthlyrate']?.toString() ?? '0') ?? 0.0,
      availabilityDays: json['availabilityDays']?.toString(),
      availabilityRange: json['pickupDateRange']?.toString(),
      images: parseImages(json['images']),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
      user: json['rentalusers'] != null
          ? UserModel.fromJson(json['rentalusers'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'categoryId': categoryId,
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

  /// Check if item has images
  bool get hasImages => images.isNotEmpty;

  /// Get first image or default
  String get firstImage => images.isNotEmpty ? images.first : ImgLinks.noItem;

  /// Get formatted price for display
  String get formattedDailyRate => '\$${dailyRate.toStringAsFixed(2)}';
  String get formattedWeeklyRate => '\$${weeklyRate.toStringAsFixed(2)}';
  String get formattedMonthlyRate => '\$${monthlyRate.toStringAsFixed(2)}';

  /// Get display title with fallback
  String get displayTitle => title.isNotEmpty ? title : 'No Title';

  /// Get short description for previews
  String get shortDescription {
    if (description == null || description!.isEmpty)
      return 'No description available';
    return description!.length > 100
        ? '${description!.substring(0, 100)}...'
        : description!;
  }

  /// Check if item is available
  bool get isAvailable =>
      availabilityDays != null && availabilityDays!.isNotEmpty;

  /// Get user display name with fallback
  String get userDisplayName => user?.displayName ?? 'Unknown User';

  /// Get user image with fallback
  String get userImageUrl => user?.fullImageUrl ?? ImgLinks.profileImage;

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
