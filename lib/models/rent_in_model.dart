class RentInModel {
  int id;
  int orderbyuid;
  dynamic userCanPickupInDateRange;
  int totalPriceByUser;
  int deliverd;
  int isRejected;
  int productId;
  int productBy;
  String productTitle;
  List<String> productImage;
  dynamic dailyrate;
  dynamic weeklyrate;
  dynamic monthlyrate;
  String availability;
  dynamic productPickupDate;
  String ipAddress;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  Productby? productby;

  RentInModel({
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
    required this.deletedAt,
    this.productby,
  });

  factory RentInModel.fromJson(Map<String, dynamic> json) => RentInModel(
    id: json["id"],
    orderbyuid: json["orderbyuid"],
    userCanPickupInDateRange: json["userCanPickupInDateRange"],
    totalPriceByUser: json["totalPriceByUser"],
    deliverd: json["deliverd"],
    isRejected: json["isRejected"],
    productId: json["productId"],
    productBy: json["product_by"],
    productTitle: json["productTitle"],
    productImage: json["productImage"] is List
        ? List<String>.from(json["productImage"].map((x) => x.toString()))
        : json["productImage"] is String
        ? [json["productImage"]]
        : [],
    dailyrate: json["dailyrate"],
    weeklyrate: json["weeklyrate"],
    monthlyrate: json["monthlyrate"],
    availability: json["availability"],
    productPickupDate: json["productPickupDate"],
    ipAddress: json["ipAddress"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    productby: json["productby"] == null
        ? null
        : Productby.fromJson(json["productby"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "orderbyuid": orderbyuid,
    "userCanPickupInDateRange": userCanPickupInDateRange,
    "totalPriceByUser": totalPriceByUser,
    "deliverd": deliverd,
    "isRejected": isRejected,
    "productId": productId,
    "product_by": productBy,
    "productTitle": productTitle,
    "productImage": List<dynamic>.from(productImage.map((x) => x)),
    "dailyrate": dailyrate,
    "weeklyrate": weeklyrate,
    "monthlyrate": monthlyrate,
    "availability": availability,
    "productPickupDate": productPickupDate,
    "ipAddress": ipAddress,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "deleted_at": deletedAt,
    "productby": productby?.toJson(),
  };

  /// Get display name with fallback
  String get displayName => productby?.name ?? 'Unknown User';

  /// Get user image with fallback
  String get fullImageUrl =>
      productby?.image != null && productby!.image.isNotEmpty
      ? 'images/' + productby!.image
      : 'assets/noimg.png';
}

class Productby {
  int id;
  String image;
  int activeUser;
  String name;
  String phone;
  String email;
  String lastOnlineTime;
  String address;
  String aboutUs;
  String verifiedBy;
  int sendEmail;
  String password;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;

  Productby({
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
    required this.deletedAt,
  });

  factory Productby.fromJson(Map<String, dynamic> json) => Productby(
    id: json["id"],
    image: json["image"],
    activeUser: json["activeUser"],
    name: json["name"],
    phone: json["phone"],
    email: json["email"],
    lastOnlineTime: json["last_online_time"],
    address: json["address"],
    aboutUs: json["aboutUs"],
    verifiedBy: json["verifiedBy"],
    sendEmail: json["sendEmail"],
    password: json["password"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
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
