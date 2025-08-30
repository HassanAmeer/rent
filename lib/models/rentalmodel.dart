class Rentalmodel {
  final int id;
  final int orderbyuid;
  final String userCanPickupInDateRange;
  final int totalPriceByUser;
  final int deliverd;
  final int isRejected;
  final int productId;
  final int productBy;
  final String productTitle;
  final List<String> productImage;
  final String dailyrate;
  final String weeklyrate;
  final String monthlyrate;
  final String availability;
  final String productPickupDate;
  final String ipAddress;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final ProductBy productby;

  Rentalmodel({
    required this.id,
    required this.orderbyuid,
    required this.userCanPickupInDateRange,
    required this.totalPriceByUser,
    required this.deliverd,
    required this.isRejected,
    required this.productId,
    required this.productBy,
    required this.productTitle,
    required this.productImage,
    required this.dailyrate,
    required this.weeklyrate,
    required this.monthlyrate,
    required this.availability,
    required this.productPickupDate,
    required this.ipAddress,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.productby,
  });

  factory Rentalmodel.fromJson(Map<String, dynamic> json) {
    return Rentalmodel(
      id: json["id"],
      orderbyuid: json["orderbyuid"],
      userCanPickupInDateRange: json["userCanPickupInDateRange"] ?? "",
      totalPriceByUser: json["totalPriceByUser"] ?? 0,
      deliverd: json["deliverd"],
      isRejected: json["isRejected"],
      productId: json["productId"],
      productBy: json["product_by"],
      productTitle: json["productTitle"],
      productImage: List<String>.from(
        (json["productImage"] != null)
            ? (json["productImage"] is String
                  ? List<String>.from(
                      (json["productImage"] as String)
                          .replaceAll('[', '')
                          .replaceAll(']', '')
                          .replaceAll('"', '')
                          .split(","),
                    )
                  : json["productImage"])
            : [],
      ),
      dailyrate: json["dailyrate"] ?? "0",
      weeklyrate: json["weeklyrate"] ?? "0",
      monthlyrate: json["monthlyrate"] ?? "0",
      availability: json["availability"] ?? "",
      productPickupDate: json["productPickupDate"] ?? "",
      ipAddress: json["ipAddress"] ?? "",
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
      deletedAt: json["deleted_at"],
      productby: ProductBy.fromJson(json["productby"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "orderbyuid": orderbyuid,
      "userCanPickupInDateRange": userCanPickupInDateRange,
      "totalPriceByUser": totalPriceByUser,
      "deliverd": deliverd,
      "isRejected": isRejected,
      "productId": productId,
      "product_by": productBy,
      "productTitle": productTitle,
      "productImage": productImage,
      "dailyrate": dailyrate,
      "weeklyrate": weeklyrate,
      "monthlyrate": monthlyrate,
      "availability": availability,
      "productPickupDate": productPickupDate,
      "ipAddress": ipAddress,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "deleted_at": deletedAt,
      "productby": productby.toJson(),
    };
  }
}

class ProductBy {
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

  ProductBy({
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

  factory ProductBy.fromJson(Map<String, dynamic> json) {
    return ProductBy(
      id: json["id"],
      image: json["image"],
      activeUser: json["activeUser"],
      name: json["name"],
      phone: json["phone"],
      email: json["email"],
      lastOnlineTime: json["last_online_time"] ?? "",
      address: json["address"] ?? "",
      aboutUs: json["aboutUs"] ?? "",
      verifiedBy: json["verifiedBy"] ?? "",
      sendEmail: json["sendEmail"] ?? 0,
      password: json["password"] ?? "",
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
      deletedAt: json["deleted_at"],
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
