/// Booking/Order Model for rental bookings
import 'dart:convert';
import 'user_model.dart';
import 'item_model.dart';

class BookingModel {
  final int id;
  final int orderByUid;
  final String? userCanPickupInDateRange;
  final double totalPriceByUser;
  final int deliverd;
  final int isRejected;
  final int productId;
  final int productBy;
  final String productTitle;
  final List<String> productImage;
  final double dailyRate;
  final double weeklyRate;
  final double monthlyRate;
  final String? availability;
  final String? productPickupDate;
  final String? ipAddress;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final UserModel? orderBy; // User who made the booking

  BookingModel({
    required this.id,
    required this.orderByUid,
    this.userCanPickupInDateRange,
    required this.totalPriceByUser,
    required this.deliverd,
    required this.isRejected,
    required this.productId,
    required this.productBy,
    required this.productTitle,
    required this.productImage,
    required this.dailyRate,
    required this.weeklyRate,
    required this.monthlyRate,
    this.availability,
    this.productPickupDate,
    this.ipAddress,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.orderBy,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
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

    return BookingModel(
      id: json['id'] ?? 0,
      orderByUid: json['orderbyuid'] ?? 0,
      userCanPickupInDateRange: json['userCanPickupInDateRange']?.toString(),
      totalPriceByUser:
          double.tryParse(
            json['totalPriceByUser']?.toString() ??
                json['totalPriceByUser']?.toString() ??
                '0',
          ) ??
          0.0,
      deliverd: json['deliverd'] ?? 0,
      isRejected: json['isRejected'] ?? 0,
      productId: json['productId'] ?? 0,
      productBy: json['product_by'] ?? 0,
      productTitle: json['productTitle']?.toString() ?? '',
      productImage: parseImages(json['productImage']),
      dailyRate: double.tryParse(json['dailyrate']?.toString() ?? '0') ?? 0.0,
      weeklyRate: double.tryParse(json['weeklyrate']?.toString() ?? '0') ?? 0.0,
      monthlyRate:
          double.tryParse(json['monthlyrate']?.toString() ?? '0') ?? 0.0,
      availability: json['availability']?.toString(),
      productPickupDate: json['productPickupDate']?.toString(),
      ipAddress: json['ipAddress']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'].toString())
          : null,
      orderBy: json['orderby'] != null
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
      'deliverd': deliverd,
      'isRejected': isRejected,
      'productId': productId,
      'product_by': productBy,
      'productTitle': productTitle,
      'productImage': productImage,
      'dailyrate': dailyRate,
      'weeklyrate': weeklyRate,
      'monthlyrate': monthlyRate,
      'availability': availability,
      'productPickupDate': productPickupDate,
      'ipAddress': ipAddress,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'orderby': orderBy?.toJson(),
    };
  }

  /// Get primary image URL
  String get primaryImageUrl {
    if (productImage.isEmpty) return '';
    return 'https://thelocalrent.com/uploads/${productImage.first}';
  }

  /// Get all image URLs
  List<String> get imageUrls {
    return productImage
        .map((img) => 'https://thelocalrent.com/uploads/$img')
        .toList();
  }

  /// Check delivery status
  bool get isDelivered => deliverd == 1;
  bool get isBookingRejected => isRejected == 1;
  bool get isPending => !isDelivered && !isBookingRejected;

  /// Get status text
  String get statusText {
    if (isBookingRejected) return 'Rejected';
    if (isDelivered) return 'Delivered';
    return 'Pending';
  }

  /// Get status color
  String get statusColor {
    if (isBookingRejected) return 'red';
    if (isDelivered) return 'green';
    return 'orange';
  }

  /// Get formatted total price
  String get formattedTotalPrice => '\$${totalPriceByUser.toStringAsFixed(2)}';

  /// Get formatted daily rate
  String get formattedDailyRate => '\$${dailyRate.toStringAsFixed(2)}';

  /// Check if booking has images
  bool get hasImages => productImage.isNotEmpty;

  @override
  String toString() {
    return 'BookingModel(id: $id, productTitle: $productTitle, status: $statusText)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BookingModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
