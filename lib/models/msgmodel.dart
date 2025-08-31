class Msgmodel {
  final int id;
  final String? image;
  final int activeUser;
  final String name;
  final String? phone;
  final String email;
  final String? lastOnlineTime;
  final String? address;
  final String? aboutUs;
  final String verifiedBy;
  final int sendEmail;
  final String password;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  Msgmodel({
    required this.id,
    this.image,
    required this.activeUser,
    required this.name,
    this.phone,
    required this.email,
    this.lastOnlineTime,
    this.address,
    this.aboutUs,
    required this.verifiedBy,
    required this.sendEmail,
    required this.password,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Msgmodel.fromJson(Map<String, dynamic> json) {
    return Msgmodel(
      id: json["id"],
      image: json["image"],
      activeUser: json["activeUser"],
      name: json["name"],
      phone: json["phone"],
      email: json["email"],
      lastOnlineTime: json["last_online_time"] ?? json["lastOnlineTime"],
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

class Message {
  final int id;
  final int sid;
  final String msg;
  final int rid;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;
  final Msgmodel fromUid;
  final Msgmodel toUid;

  Message({
    required this.id,
    required this.sid,
    required this.msg,
    required this.rid,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.fromUid,
    required this.toUid,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json["id"],
      sid: json["sid"],
      msg: json["msg"],
      rid: json["rid"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      deletedAt: json["deleted_at"],
      fromUid: Msgmodel.fromJson(json["fromuid"]),
      toUid: Msgmodel.fromJson(json["touid"]),
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
      "fromuid": fromUid.toJson(),
      "touid": toUid.toJson(),
    };
  }
}
