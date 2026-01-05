import 'package:rent/constants/api_endpoints.dart';
import 'package:rent/constants/images.dart';
import 'package:rent/constants/tostring.dart';

/// User Model for API responses and data handling
class UserModel {
  final int id;
  final String? image;
  final int activeUser;
  final String name;
  final String? phone;
  final String email;
  final String? address;
  final String? aboutUs;
  final String verifiedBy;
  final int sendEmail;
  final String password;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  UserModel({
    required this.id,
    this.image = ImgLinks.profileImage,
    this.activeUser = 0,
    this.name = "",
    this.phone,
    this.email = "empty@gmail.com",
    this.address,
    this.aboutUs,
    this.verifiedBy = "google",
    this.sendEmail = 1,
    this.password = "12345678",
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 1,
      image: json['image'] != null && json['image'].toString().trim().isNotEmpty
          ? Api.imgPath + json['image'].toString()
          : ImgLinks.profileImage,
      activeUser: json['activeUser'] ?? 0,
      name: (json['name']?.toString() ?? '').toNullStringOrDemo('Demo User'),
      phone: json['phone']?.toString(),
      email: (json['email']?.toString() ?? '').toNullStringOrDemo(
        'demo@example.com',
      ),
      address: json['address']?.toString(),
      aboutUs: json['aboutUs']?.toString(),
      verifiedBy: (json['verifiedBy']?.toString() ?? '').toNullStringOrDemo(
        'google',
      ),
      sendEmail: json['sendEmail'] ?? 0,
      password: (json['password']?.toString() ?? '').toNullStringOrDemo(
        '12345678',
      ),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at'].toString())
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
      'address': address,
      'aboutUs': aboutUs,
      'verifiedBy': verifiedBy,
      'sendEmail': sendEmail,
      'password': password,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
    };
  }

  /// Get full image URL with null safety
  String get fullImageUrl {
    if (image == null || image!.trim().isEmpty) return '';
    return 'https://thelocalrent.com/uploads/$image';
  }

  /// Check if user has a valid image
  bool get hasImage => image != null && image!.trim().isNotEmpty;

  /// Check if user is active
  bool get isActive => activeUser == 1;

  /// Get display name (fallback to email if name is empty)
  String get displayName => name.isNotEmpty ? name : email;

  /// Check if user has complete profile
  bool get hasCompleteProfile =>
      phone != null &&
      phone!.isNotEmpty &&
      address != null &&
      address!.isNotEmpty &&
      aboutUs != null &&
      aboutUs!.isNotEmpty;

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
