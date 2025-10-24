/// Favorite Item Model for favorites management
library;

import 'dart:convert';
import 'package:rent/constants/api_endpoints.dart';
import 'package:rent/constants/images.dart';
import 'package:rent/constants/tostring.dart';

class FavoriteModel {
  final int id;
  final int favoriteBy;
  final int itemId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final FavoriteItemModel? products; // The favorited item details
  final FavoriteUserModel? rentalusers; // The user who favorited

  FavoriteModel({
    this.id = 0,
    this.favoriteBy = 0,
    this.itemId = 0,
    this.createdAt,
    this.updatedAt,
    this.products,
    this.rentalusers,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'] ?? 0,
      favoriteBy: json['favoriteBy'] ?? 0,
      itemId: json['itemId'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
      products: json['products'] != null
          ? FavoriteItemModel.fromJson(json['products'])
          : null,
      rentalusers: json['rentalusers'] != null
          ? FavoriteUserModel.fromJson(json['rentalusers'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'favoriteBy': favoriteBy,
      'itemId': itemId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'products': products?.toJson(),
      'rentalusers': rentalusers?.toJson(),
    };
  }

  /// Get display title from item
  String get displayTitle => products?.title ?? 'No Title';

  /// Get item images
  List<String> get itemImages => products?.images ?? [ImgLinks.noItem];

  /// Get item description
  String get itemDescription =>
      products?.description ?? 'No description available';

  /// Get formatted daily rate
  String get formattedDailyRate => products?.formattedDailyRate ?? '\$0.00';

  /// Get first image or default
  String get firstImage =>
      itemImages.isNotEmpty ? itemImages.first : ImgLinks.noItem;

  /// Check if favorite has valid item
  bool get hasValidItem => products != null;

  @override
  String toString() {
    return 'FavoriteModel(id: $id, itemId: $itemId, displayTitle: $displayTitle)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FavoriteModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

class FavoriteItemModel {
  final int id;
  final int productBy;
  final String title;
  final String? description;
  final int? category;
  final int showProduct;
  final List<String> images;
  final int dailyrate;
  final int weeklyrate;
  final int monthlyrate;
  final String? availabilityDays;
  final String? pickupDateRange;
  final int allowReviews;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FavoriteItemModel({
    this.id = 0,
    this.productBy = 0,
    this.title = 'No Title',
    this.description,
    this.category,
    this.showProduct = 0,
    this.images = const [],
    this.dailyrate = 0,
    this.weeklyrate = 0,
    this.monthlyrate = 0,
    this.availabilityDays,
    this.pickupDateRange,
    this.allowReviews = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory FavoriteItemModel.fromJson(Map<String, dynamic> json) {
    List<String> parseImages(dynamic imagesData) {
      if (imagesData == null) return [];
      if (imagesData is List) {
        return imagesData.map((img) => Api.imgPath + img.toString()).toList();
      }
      return [];
    }

    return FavoriteItemModel(
      id: json['id'] ?? 0,
      productBy: json['productBy'] ?? 0,
      title: json['title']?.toString() ?? 'No Title',
      description: json['description']?.toString(),
      category: int.tryParse(json['category'].toString().toNullString()) ?? 0,
      showProduct: json['showProduct'] ?? 0,
      images: parseImages(json['images']),
      dailyrate: int.tryParse(json['dailyrate']) ?? 0,
      weeklyrate: int.tryParse(json['weeklyrate']) ?? 0,
      monthlyrate: int.tryParse(json['monthlyrate']) ?? 0,
      availabilityDays: json['availabilityDays']?.toString(),
      pickupDateRange: json['pickupDateRange']?.toString(),
      allowReviews: json['allowReviews'] ?? 0,
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
      'productBy': productBy,
      'title': title,
      'description': description,
      'category': category,
      'showProduct': showProduct,
      'images': images,
      'dailyrate': dailyrate,
      'weeklyrate': weeklyrate,
      'monthlyrate': monthlyrate,
      'availabilityDays': availabilityDays,
      'pickupDateRange': pickupDateRange,
      'allowReviews': allowReviews,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Get formatted price for display
  String get formattedDailyRate => '\$${dailyrate.toStringAsFixed(2)}';
  String get formattedWeeklyRate => '\$${weeklyrate.toStringAsFixed(2)}';
  String get formattedMonthlyRate => '\$${monthlyrate.toStringAsFixed(2)}';

  /// Get short description for previews
  String get shortDescription {
    if (description == null || description!.isEmpty)
      return 'No description available';
    return description!.length > 100
        ? '${description!.substring(0, 100)}...'
        : description!;
  }

  /// Check if item has images
  bool get hasImages => images.isNotEmpty;

  /// Get first image or default
  String get firstImage => images.isNotEmpty ? images.first : ImgLinks.noItem;
}

class FavoriteUserModel {
  final int id;
  final String image;
  final int activeUser;
  final String name;
  final String phone;
  final String email;
  final String? lastOnlineTime;
  final String? address;
  final String? aboutUs;
  final String? verifiedBy;
  final int sendEmail;
  final String password;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FavoriteUserModel({
    this.id = 0,
    this.image = '',
    this.activeUser = 0,
    this.name = 'Unknown User',
    this.phone = '',
    this.email = '',
    this.lastOnlineTime,
    this.address,
    this.aboutUs,
    this.verifiedBy,
    this.sendEmail = 0,
    this.password = '',
    this.createdAt,
    this.updatedAt,
  });

  factory FavoriteUserModel.fromJson(Map<String, dynamic> json) {
    return FavoriteUserModel(
      id: json['id'] ?? 0,
      image: json['image'] != null
          ? Api.imgPath + json['image']
          : ImgLinks.profileImage,
      activeUser: json['activeUser'] ?? 0,
      name: json['name']?.toString() ?? 'Unknown User',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      lastOnlineTime: json['last_online_time']?.toString(),
      address: json['address']?.toString(),
      aboutUs: json['aboutUs']?.toString(),
      verifiedBy: json['verifiedBy']?.toString(),
      sendEmail: json['sendEmail'] ?? 0,
      password: json['password']?.toString() ?? '',
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
      'activeUser': activeUser,
      'name': name,
      'phone': phone,
      'email': email,
      'last_online_time': lastOnlineTime,
      'address': address,
      'aboutUs': aboutUs,
      'verifiedBy': verifiedBy,
      'sendEmail': sendEmail,
      'password': password,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Get display name with fallback
  String get displayName => name.isNotEmpty ? name : 'Unknown User';

  /// Get user image with fallback
  String get fullImageUrl => image.isNotEmpty ? image : ImgLinks.profileImage;
}
