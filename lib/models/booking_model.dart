/// Booking/Order Model for booking and order management
library;

import 'dart:convert';
import 'package:rent/constants/api_endpoints.dart';
import 'package:rent/constants/images.dart';
import 'user_model.dart';

class BookingModel {
  final int id;
  final int orderByUid;
  final String userCanPickupInDateRange;
  final double totalPriceByUser;
  final int delivered;
  final int isRejected;
  final int productId;
  final int productBy;
  final String productTitle;
  final List<String> productImages;
  final double dailyRate;
  final double weeklyRate;
  final double monthlyRate;
  final String availability;
  final String productPickupDate;
  final String ipAddress;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final UserModel? orderByUser; // User who placed the order

  BookingModel({
    this.id = 0,
    this.orderByUid = 0,
    this.userCanPickupInDateRange = '',
    this.totalPriceByUser = 0.0,
    this.delivered = 0,
    this.isRejected = 0,
    this.productId = 0,
    this.productBy = 0,
    this.productTitle = '',
    this.productImages = const [ImgLinks.noItem, ImgLinks.noItem],
    this.dailyRate = 0.0,
    this.weeklyRate = 0.0,
    this.monthlyRate = 0.0,
    this.availability = '',
    this.productPickupDate = '',
    this.ipAddress = '',
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.orderByUser,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
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

    return BookingModel(
      id: json['id'] ?? 0,
      orderByUid: json['orderbyuid'] ?? 0,
      userCanPickupInDateRange:
          json['userCanPickupInDateRange']?.toString() ?? '',
      totalPriceByUser:
          double.tryParse(json['totalPriceByUser']?.toString() ?? '0') ?? 0.0,
      delivered: json['deliverd'] ?? 0,
      isRejected: json['isRejected'] ?? 0,
      productId: json['productId'] ?? 0,
      productBy: json['product_by'] ?? 0,
      productTitle: json['productTitle']?.toString() ?? '',
      productImages: parseImages(json['productImage']),
      dailyRate: double.tryParse(json['dailyrate']?.toString() ?? '0') ?? 0.0,
      weeklyRate: double.tryParse(json['weeklyrate']?.toString() ?? '0') ?? 0.0,
      monthlyRate:
          double.tryParse(json['monthlyrate']?.toString() ?? '0') ?? 0.0,
      availability: json['availability']?.toString() ?? '',
      productPickupDate: json['productPickupDate']?.toString() ?? '',
      ipAddress: json['ipAddress']?.toString() ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'].toString())
          : null,
      orderByUser: json['orderby'] != null
          ? UserModel.fromJson(json['orderby'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderbyuid': orderByUid,
      'userCanPickupInDateRange': userCanPickupInDateRange,
      'totalPriceByUser': totalPriceByUser,
      'deliverd': delivered,
      'isRejected': isRejected,
      'productId': productId,
      'product_by': productBy,
      'productTitle': productTitle,
      'productImage': productImages,
      'dailyrate': dailyRate,
      'weeklyrate': weeklyRate,
      'monthlyrate': monthlyRate,
      'availability': availability,
      'productPickupDate': productPickupDate,
      'ipAddress': ipAddress,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'orderby': orderByUser?.toJson(),
    };
  }

  /// Check if booking has images
  bool get hasImages => productImages.isNotEmpty;

  /// Get formatted price for display
  String get formattedTotalPrice => '\$${totalPriceByUser.toStringAsFixed(2)}';
  String get formattedDailyRate => '\$${dailyRate.toStringAsFixed(2)}';
  String get formattedWeeklyRate => '\$${weeklyRate.toStringAsFixed(2)}';
  String get formattedMonthlyRate => '\$${monthlyRate.toStringAsFixed(2)}';

  /// Get display title with fallback
  String get displayTitle =>
      productTitle.isNotEmpty ? productTitle : 'Unknown Product';

  /// Get short description for previews
  String get shortPickupDate {
    if (productPickupDate.isEmpty) return '';
    return productPickupDate.length > 50
        ? '${productPickupDate.substring(0, 50)}...'
        : productPickupDate;
  }

  /// Check if booking is delivered
  bool get isDelivered => delivered == 1;

  /// Check if booking is rejected
  bool get isRejectedBooking => isRejected == 1;

  @override
  String toString() {
    return 'BookingModel(id: $id, productTitle: $productTitle, totalPrice: $totalPriceByUser)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BookingModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
