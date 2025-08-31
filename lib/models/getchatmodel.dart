class GetChatModel {
  final bool success;
  final String msg;
  final User senderUser;
  final User recieverUser;
  final List<ChatMessage> chats;

  GetChatModel({
    required this.success,
    required this.msg,
    required this.senderUser,
    required this.recieverUser,
    required this.chats,
  });

  factory GetChatModel.fromJson(Map<String, dynamic> json) {
    return GetChatModel(
      success: json['success'] ?? false,
      msg: json['msg'] ?? '',
      senderUser: User.fromJson(json['senderUser']),
      recieverUser: User.fromJson(json['recieverUser']),
      chats: (json['chats'] as List<dynamic>)
          .map((e) => ChatMessage.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'msg': msg,
      'senderUser': senderUser.toJson(),
      'recieverUser': recieverUser.toJson(),
      'chats': chats.map((e) => e.toJson()).toList(),
    };
  }
}

class User {
  final int id;
  final String? image;
  final int activeUser;
  final String name;
  final String? phone;
  final String email;
  final String? lastOnlineTime;
  final String? address;
  final String? aboutUs;
  final String? verifiedBy;
  final int sendEmail;
  final String? password;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  User({
    required this.id,
    this.image,
    required this.activeUser,
    required this.name,
    this.phone,
    required this.email,
    this.lastOnlineTime,
    this.address,
    this.aboutUs,
    this.verifiedBy,
    required this.sendEmail,
    this.password,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
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
      'id': id,
      'image': image,
      'activeUser': activeUser,
      'name': name,
      'phone': phone,
      'email': email,
      'last_online_time': lastOnlineTime,
      'address': address,
      'aboutUs': aboutUs,
      'verifiedBy': verifiedBy,
      'sendEmail': sendEmail,
      'password': password,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}

class ChatMessage {
  final int id;
  final int sid;
  final String msg;
  final int rid;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  ChatMessage({
    required this.id,
    required this.sid,
    required this.msg,
    required this.rid,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      sid: json['sid'],
      msg: json['msg'],
      rid: json['rid'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sid': sid,
      'msg': msg,
      'rid': rid,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
