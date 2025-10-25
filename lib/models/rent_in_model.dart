import 'package:rent/constants/images.dart';

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
  dynamic createdAt;
  dynamic updatedAt;
  dynamic deletedAt;
  Productby? productby;

  RentInModel({
    this.id = 0,
    this.orderbyuid = 0,
    this.userCanPickupInDateRange = 0,
    this.totalPriceByUser = 0,
    this.deliverd = 0,
    this.isRejected = 0,
    this.productId = 0,
    this.productBy = 0,
    this.productTitle = "",
    this.productImage = const [ImgLinks.noItem, ImgLinks.noItem],
    this.dailyrate = 0,
    this.weeklyrate = 0,
    this.monthlyrate = 0,
    this.availability = "",
    this.productPickupDate = 0,
    this.ipAddress = "",
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt = "",
    this.productby,
  });

  factory RentInModel.fromJson(Map<String, dynamic> json) => RentInModel(
    id: json["id"] ?? 0,
    orderbyuid: json["orderbyuid"] ?? 0,
    userCanPickupInDateRange: json["userCanPickupInDateRange"] ?? 0,
    totalPriceByUser: json["totalPriceByUser"] ?? 0,
    deliverd: json["deliverd"] ?? 0,
    isRejected: json["isRejected"] ?? 0,
    productId: json["productId"] ?? 0,
    productBy: json["product_by"] ?? 0,
    productTitle: json["productTitle"] ?? "",
    productImage: json["productImage"] is List
        ? List<String>.from(json["productImage"].map((x) => x.toString()))
        : json["productImage"] is String
        ? [json["productImage"]]
        : [ImgLinks.noItem, ImgLinks.noItem],
    dailyrate: json["dailyrate"] ?? '',
    weeklyrate: json["weeklyrate"] ?? '',
    monthlyrate: json["monthlyrate"] ?? '',
    availability: json["availability"] ?? '',
    productPickupDate: json["productPickupDate"] ?? '',
    ipAddress: json["ipAddress"] ?? '',
    createdAt: DateTime.parse(json["created_at"]) ?? '',
    updatedAt: DateTime.parse(json["updated_at"]) ?? '',
    deletedAt: json["deleted_at"] ?? '',
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
