import 'package:rent/constants/api_endpoints.dart';
import 'package:rent/constants/tostring.dart';

class ChatedUsersModel {
  int? id;
  int? sid;
  String? msg;
  int? rid;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  ChatUser? fromuid;
  ChatUser? touid;

  ChatedUsersModel({
    this.id,
    this.sid,
    this.msg,
    this.rid,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.fromuid,
    this.touid,
  });

  ChatedUsersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    sid = json['sid'] as int?;
    msg = json['msg']?.toString().toNullString();
    rid = json['rid'] as int?;
    createdAt = json['created_at']?.toString().toNullString();
    updatedAt = json['updated_at']?.toString().toNullString();
    deletedAt = json['deleted_at'];
    fromuid = json['fromuid'] == null
        ? null
        : ChatUser.fromJson(json['fromuid'] as Map<String, dynamic>);
    touid = json['touid'] == null
        ? null
        : ChatUser.fromJson(json['touid'] as Map<String, dynamic>);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sid'] = sid;
    data['msg'] = msg;
    data['rid'] = rid;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (fromuid != null) {
      data['fromuid'] = fromuid!.toJson();
    }
    if (touid != null) {
      data['touid'] = touid!.toJson();
    }
    return data;
  }

  String toNullString() {
    return toString().toNullString();
  }

  @override
  String toString() {
    return 'ChatedUsersModel{id: $id, sid: $sid, msg: $msg, rid: $rid, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, fromuid: $fromuid, touid: $touid}';
  }
}

class ChatUser {
  int? id;
  String? image;
  int? activeUser;
  String? name;
  String? phone;
  String? email;
  String? lastOnlineTime;
  String? address;
  String? aboutUs;
  String? verifiedBy;
  int? sendEmail;
  String? password;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;

  ChatUser({
    this.id,
    this.image,
    this.activeUser,
    this.name,
    this.phone,
    this.email,
    this.lastOnlineTime,
    this.address,
    this.aboutUs,
    this.verifiedBy,
    this.sendEmail,
    this.password,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  ChatUser.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    // ✅ Safe image handling - prevents crash on null
    image = json['image'] != null && json['image'].toString().trim().isNotEmpty
        ? Api.imgPath + json['image'].toString()
        : '';
    activeUser = json['activeUser'] as int?;
    name = json['name']?.toString().toNullString();
    phone = json['phone']?.toString().toNullString();
    email = json['email']?.toString().toNullString();
    lastOnlineTime = json['last_online_time']?.toString().toNullString();
    address = json['address']?.toString().toNullString();
    aboutUs = json['aboutUs']?.toString().toNullString();
    verifiedBy = json['verifiedBy']?.toString().toNullString();
    sendEmail = json['sendEmail'] as int?;
    password = json['password']?.toString().toNullString();
    createdAt = json['created_at']?.toString().toNullString();
    updatedAt = json['updated_at']?.toString().toNullString();
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['activeUser'] = activeUser;
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['last_online_time'] = lastOnlineTime;
    data['address'] = address;
    data['aboutUs'] = aboutUs;
    data['verifiedBy'] = verifiedBy;
    data['sendEmail'] = sendEmail;
    data['password'] = password;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }

  String toNullString() {
    return toString().toNullString();
  }

  @override
  String toString() {
    return 'ChatUser{id: $id, name: $name}';
  }
}
