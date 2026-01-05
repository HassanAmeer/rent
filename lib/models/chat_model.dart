import 'package:rent/constants/tostring.dart';

import '../constants/api_endpoints.dart';

class ChatModel {
  bool? success;
  String? msg;
  // ChatUser? senderUser;
  // ChatUser? recieverUser;
  List<ChatMessage>? chats;

  ChatModel({
    this.success,
    this.msg,
    // this.senderUser,
    // this.recieverUser,
    this.chats,
  });

  ChatModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    msg = json['msg']?.toString().toNullString();
    // senderUser = json['senderUser'] == null
    //     ? null
    //     : ChatUser.fromJson(json['senderUser'] as Map<String, dynamic>);
    // recieverUser = json['recieverUser'] == null
    //     ? null
    //     : ChatUser.fromJson(json['recieverUser'] as Map<String, dynamic>);
    if (json['chats'] != null) {
      chats = <ChatMessage>[];
      for (var v in (json['chats'] as List)) {
        chats!.add(ChatMessage.fromJson(v as Map<String, dynamic>));
      }
    }
    chats = chats?.reversed.toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['msg'] = msg;
    // if (this.senderUser != null) {
    //   data['senderUser'] = this.senderUser!.toJson();
    // }
    // if (this.recieverUser != null) {
    //   data['recieverUser'] = this.recieverUser!.toJson();
    // }
    if (chats != null) {
      data['chats'] = chats!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  String toNullString() {
    return toString();
  }

  @override
  String toString() {
    return '''ChatModel{success: $success, msg: $msg, chats: $chats}''';
    // senderUser: $senderUser, recieverUser: $recieverUser,
  }
}

class ChatMessage {
  int? id;
  int? sid;
  String? msg;
  int? rid;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;

  ChatMessage({
    this.id,
    this.sid,
    this.msg,
    this.rid,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  ChatMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    sid = json['sid'] as int?;
    msg = json['msg']?.toString().toNullString();
    rid = json['rid'] as int?;
    createdAt = json['created_at']?.toString().toNullString();
    updatedAt = json['updated_at']?.toString().toNullString();
    deletedAt = json['deleted_at'];
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
    return data;
  }

  String toNullString() {
    return toString();
  }

  @override
  String toString() {
    return 'ChatMessage{id: $id, sid: $sid, msg: $msg, rid: $rid, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt}';
  }
}

class ChatUser {
  String? id;
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
    id = json['id'].toString().toNullString();
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
    return toString();
  }

  @override
  String toString() {
    return 'ChatUser{id: $id, name: $name}';
  }
}
