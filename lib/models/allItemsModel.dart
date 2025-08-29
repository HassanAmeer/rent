import '../constants/images.dart';

class AllItemsModel {
  final int id;
  final int productBy;
  final String title;
  final int showProduct;
  final String category;
  final String description;
  List<String> images;
  final String dailyrate;
  final String weeklyrate;
  final String monthlyrate;
  final String availabilityDays;
  final String pickupDateRange;
  final int allowReviews;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final RentalUser rentalUser;

  AllItemsModel({
    required this.id,
    required this.productBy,
    required this.title,
    required this.showProduct,
    required this.category,
    required this.description,
    this.images = const [
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQi50zTLuADwdCHUNWNkOxgIh05Uo3ma8euw&s",
    ],
    required this.dailyrate,
    required this.weeklyrate,
    required this.monthlyrate,
    required this.availabilityDays,
    required this.pickupDateRange,
    required this.allowReviews,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.rentalUser,
  });

  factory AllItemsModel.fromJson(Map<String, dynamic> json) {
    return AllItemsModel(
      id: json['id'] ?? 0,
      productBy: json['productBy'] ?? 0,
      title: json['title'] ?? '',
      showProduct: json['showProduct'] ?? 0,
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      dailyrate: json['dailyrate'] ?? '',
      weeklyrate: json['weeklyrate'] ?? '',
      monthlyrate: json['monthlyrate'] ?? '',
      availabilityDays: json['availabilityDays'] ?? '',
      pickupDateRange: json['pickupDateRange'] ?? '',
      allowReviews: json['allowReviews'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at'] ?? "",
      rentalUser: RentalUser.fromJson(json['rentalusers'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productBy': productBy,
      'title': title,
      'showProduct': showProduct,
      'category': category,
      'description': description,
      'images': images,
      'dailyrate': dailyrate,
      'weeklyrate': weeklyrate,
      'monthlyrate': monthlyrate,
      'availabilityDays': availabilityDays,
      'pickupDateRange': pickupDateRange,
      'allowReviews': allowReviews,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'rentalusers': rentalUser.toJson(),
    };
  }
}

class RentalUser {
  final int id;
  final String image;
  final int activeUser;
  final String name;
  final String phone;
  final String email;
  final String lastOnlineTime;
  final String address;
  final String? aboutUs;
  final String verifiedBy;
  final int sendEmail;
  final String password;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  RentalUser({
    required this.id,
    required this.image,
    required this.activeUser,
    required this.name,
    required this.phone,
    required this.email,
    required this.lastOnlineTime,
    required this.address,
    this.aboutUs,
    required this.verifiedBy,
    required this.sendEmail,
    required this.password,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory RentalUser.fromJson(Map<String, dynamic> json) {
    return RentalUser(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      activeUser: json['activeUser'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      lastOnlineTime: json['last_online_time'] ?? '',
      address: json['address'] ?? '',
      aboutUs: json['aboutUs'],
      verifiedBy: json['verifiedBy'] ?? '',
      sendEmail: json['sendEmail'] ?? 0,
      password: json['password'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at'],
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
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
