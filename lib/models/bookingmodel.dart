import 'dart:convert';

class OrderModel {
  final int id;
  final int orderByUid;
  final String userCanPickupInDateRange;
  final int totalPriceByUser;
  final int deliverd;
  final int isRejected;
  final int productId;
  final int productBy;
  final String productTitle;
  final List<String> productImage; // converted from string → List<String>
  final String dailyrate;
  final String weeklyrate;
  final String monthlyrate;
  final String availability;
  final String productPickupDate;
  final String ipAddress;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final OrderBy orderBy;

  OrderModel({
    required this.id,
    required this.orderByUid,
    required this.userCanPickupInDateRange,
    required this.totalPriceByUser,
    required this.deliverd,
    required this.isRejected,
    required this.productId,
    required this.productBy,
    required this.productTitle,
    this.productImage = const [
      "https://cdn-icons-png.flaticon.com/128/2674/2674486.png",
    ],
    required this.dailyrate,
    required this.weeklyrate,
    required this.monthlyrate,
    required this.availability,
    required this.productPickupDate,
    required this.ipAddress,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.orderBy,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      orderByUid: json['orderbyuid'],
      userCanPickupInDateRange: json['userCanPickupInDateRange'],
      totalPriceByUser: json['totalPriceByUser'],
      deliverd: json['deliverd'],
      isRejected: json['isRejected'],
      productId: json['productId'],
      productBy: json['product_by'],
      productTitle: json['productTitle'],
      productImage: List<String>.from(
        jsonDecode(jsonDecode(json['productImage'])),
      ),
      dailyrate: json['dailyrate'],
      weeklyrate: json['weeklyrate'],
      monthlyrate: json['monthlyrate'],
      availability: json['availability'],
      productPickupDate: json['productPickupDate'],
      ipAddress: json['ipAddress'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      orderBy: OrderBy.fromJson(json['orderby']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "orderbyuid": orderByUid,
      "userCanPickupInDateRange": userCanPickupInDateRange,
      "totalPriceByUser": totalPriceByUser,
      "deliverd": deliverd,
      "isRejected": isRejected,
      "productId": productId,
      "product_by": productBy,
      "productTitle": productTitle,
      "productImage": jsonEncode(productImage),
      "dailyrate": dailyrate,
      "weeklyrate": weeklyrate,
      "monthlyrate": monthlyrate,
      "availability": availability,
      "productPickupDate": productPickupDate,
      "ipAddress": ipAddress,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "deleted_at": deletedAt,
      "orderby": orderBy.toJson(),
    };
  }
}

class OrderBy {
  final int id;
  final String image;
  final int activeUser;
  final String name;
  final String phone;
  final String email;
  final String lastOnlineTime;
  final String address;
  final String aboutUs;
  final String verifiedBy;
  final int sendEmail;
  final String password;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  OrderBy({
    required this.id,
    required this.image,
    required this.activeUser,
    required this.name,
    required this.phone,
    required this.email,
    required this.lastOnlineTime,
    required this.address,
    required this.aboutUs,
    required this.verifiedBy,
    required this.sendEmail,
    required this.password,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory OrderBy.fromJson(Map<String, dynamic> json) {
    return OrderBy(
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
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
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
      "created_at": createdAt,
      "updated_at": updatedAt,
      "deleted_at": deletedAt,
    };
  }
}
