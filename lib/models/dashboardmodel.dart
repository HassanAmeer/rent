class DashboardModel {
  final bool success;
  final String msg;
  final UserModel user;
  final int totalEarning;
  final List<String> productTitelsListForChart;
  final List<int> orderCountsListForChart;
  final List<int> rentalCountsListForChart;
  final double totalReviewsRatio;
  final List<LastUserMsg> lastUsersMsgs;

  DashboardModel({
    this.success = false,
    this.msg = "",
    required this.user,
    this.totalEarning = 0,
    this.productTitelsListForChart = const [
      "@",
      "@",
      "@",
      "@",
      "@",
      "@",
      "@",
      "@",
    ],
    this.orderCountsListForChart = const [0, 0, 0, 0, 0, 0, 0, 0],
    this.rentalCountsListForChart = const [0, 0, 0, 0, 0, 0, 0, 0],
    this.totalReviewsRatio = 0.0,
    required this.lastUsersMsgs,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      success: json['success'],
      msg: json['msg'],
      user: UserModel.fromJson(json['user']),
      totalEarning: json['totalEarning'],
      productTitelsListForChart: List<String>.from(
        json['productTitelsListForChart'],
      ),
      orderCountsListForChart: List<int>.from(json['orderCountsListForChart']),
      rentalCountsListForChart: List<int>.from(
        json['rentalCountsListForChart'],
      ),
      totalReviewsRatio: json['totalReviewsRatio']?.toDouble() ?? 0.0,
      lastUsersMsgs: (json['lastUsersMsgs'] as List)
          .map((e) => LastUserMsg.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "msg": msg,
      "user": user.toJson(),
      "totalEarning": totalEarning,
      "productTitelsListForChart": productTitelsListForChart,
      "orderCountsListForChart": orderCountsListForChart,
      "rentalCountsListForChart": rentalCountsListForChart,
      "totalReviewsRatio": totalReviewsRatio,
      "lastUsersMsgs": lastUsersMsgs.map((e) => e.toJson()).toList(),
    };
  }
}

class UserModel {
  final int id;
  final String? image;
  final int activeUser;
  final String name;
  final String? phone;
  final String email;
  final String lastOnlineTime;
  final String? address;
  final String? aboutUs;
  final String? verifiedBy;
  final int sendEmail;
  final String password;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  UserModel({
    this.id = 00,
    this.image,
    this.activeUser = 0,
    this.name = "",
    this.phone,
    this.email = "",
    this.lastOnlineTime = "",
    this.address,
    this.aboutUs,
    this.verifiedBy,
    this.sendEmail = 0,
    this.password = "",
    this.createdAt = "",
    required this.updatedAt,
    this.deletedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
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
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
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

class LastUserMsg {
  final int id;
  final int sid;
  final String msg;
  final int rid;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final UserModel fromuid;
  final UserModel touid;

  LastUserMsg({
    required this.id,
    required this.sid,
    required this.msg,
    required this.rid,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.fromuid,
    required this.touid,
  });

  factory LastUserMsg.fromJson(Map<String, dynamic> json) {
    return LastUserMsg(
      id: json["id"],
      sid: json["sid"],
      msg: json["msg"],
      rid: json["rid"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      deletedAt: json["deleted_at"],
      fromuid: UserModel.fromJson(json["fromuid"]),
      touid: UserModel.fromJson(json["touid"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "sid": sid,
      "msg": msg,
      "rid": rid,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "deleted_at": deletedAt,
      "fromuid": fromuid.toJson(),
      "touid": touid.toJson(),
    };
  }
}
