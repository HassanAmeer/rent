class ChatedUsersModel {
  final bool success;
  final String msg;
  final List<ChatedUser> chatedUsers;

  ChatedUsersModel({
    required this.success,
    required this.msg,
    required this.chatedUsers,
  });

  factory ChatedUsersModel.fromJson(Map<String, dynamic> json) {
    return ChatedUsersModel(
      success: json['success'] ?? false,
      msg: json['msg'] ?? '',
      chatedUsers: (json['chatedUsers'] as List<dynamic>? ?? [])
          .map((e) => ChatedUser.fromJson(e))
          .toList(),
    );
  }
}
//      ( var chatedUsers = [];
//       for (int i =0; i<data['chatedUsers'].length; i++){
// chatedUsers.add(ChatedUser.fromJson(data['chatedUsers']));
//       }
//      )

class ChatedUser {
  final int id;
  final int sid;
  final String msg;
  final int rid;
  final String createdAt;
  final String updatedAt;
  final dynamic deletedAt;
  final User fromuid;
  final User touid;

  ChatedUser({
    required this.id,
    required this.sid,
    required this.msg,
    required this.rid,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.fromuid,
    required this.touid,
  });

  factory ChatedUser.fromJson(Map<String, dynamic> json) {
    return ChatedUser(
      id: json['id'] ?? 0,
      sid: json['sid'] ?? 0,
      msg: json['msg'] ?? '',
      rid: json['rid'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      deletedAt: json['deleted_at'],
      fromuid: User.fromJson(json['fromuid'] ?? {}),
      touid: User.fromJson(json['touid'] ?? {}),
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

class User {
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
  final dynamic deletedAt;

  User({
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

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      activeUser: json['activeUser'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      lastOnlineTime: json['last_online_time'] ?? '',
      address: json['address'] ?? '',
      aboutUs: json['aboutUs'] ?? '',
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
