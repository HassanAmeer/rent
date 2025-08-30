class ListingModel {
  final int id;
  final int productBy;
  final String title;
  final int showProduct;
  final String category;
  final String description;
  final List<String> images;
  final String dailyrate;
  final String weeklyrate;
  final String monthlyrate;
  final String availabilityDays;
  final String pickupDateRange;
  final int allowReviews;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? deletedAt;
  final RentalUser rentalUser;

  ListingModel({
    required this.id,
    required this.productBy,
    required this.title,
    required this.showProduct,
    required this.category,
    required this.description,
    required this.images,
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

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    return ListingModel(
      id: json['id'],
      productBy: json['productBy'],
      title: json['title'],
      showProduct: json['showProduct'],
      category: json['category'],
      description: json['description'],
      images: List<String>.from(json['images']),
      dailyrate: json['dailyrate'],
      weeklyrate: json['weeklyrate'],
      monthlyrate: json['monthlyrate'],
      availabilityDays: json['availabilityDays'],
      pickupDateRange: json['pickupDateRange'],
      allowReviews: json['allowReviews'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'],
      rentalUser: RentalUser.fromJson(json['rentalusers']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "productBy": productBy,
      "title": title,
      "showProduct": showProduct,
      "category": category,
      "description": description,
      "images": images,
      "dailyrate": dailyrate,
      "weeklyrate": weeklyrate,
      "monthlyrate": monthlyrate,
      "availabilityDays": availabilityDays,
      "pickupDateRange": pickupDateRange,
      "allowReviews": allowReviews,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
      "deleted_at": deletedAt,
      "rentalusers": rentalUser.toJson(),
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
  final DateTime createdAt;
  final DateTime updatedAt;
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
      id: json['id'],
      image: json['image'],
      activeUser: json['activeUser'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      lastOnlineTime: json['last_online_time'],
      address: json['address'],
      aboutUs: json['aboutUs'],
      verifiedBy: json['verifiedBy'],
      sendEmail: json['sendEmail'],
      password: json['password'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "image": image,
      "activeUser": activeUser,
      "name": name,
      "phone": phone,
      "email": email,
      "last_online_time": lastOnlineTime,
      "address": address,
      "aboutUs": aboutUs,
      "verifiedBy": verifiedBy,
      "sendEmail": sendEmail,
      "password": password,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt.toIso8601String(),
      "deleted_at": deletedAt,
    };
  }
}
