class Notificationmodel {
  final int id;
  final int from;
  final int to;
  final String title;
  final String desc;
  final String createdAt;
  final String updatedAt;
  final FromUser fromUser;

  Notificationmodel({
    required this.id,
    required this.from,
    required this.to,
    required this.title,
    required this.desc,
    required this.createdAt,
    required this.updatedAt,
    required this.fromUser,
  });

  factory Notificationmodel.fromJson(Map<String, dynamic> json) {
    return Notificationmodel(
      id: json['id'] ?? 0,
      from: json['from'] ?? 0,
      to: json['to'] ?? 0,
      title: json['title'] ?? '',
      desc: json['desc'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      fromUser: FromUser.fromJson(json['fromuid'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from': from,
      'to': to,
      'title': title,
      'desc': desc,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'fromuid': fromUser.toJson(),
    };
  }
}

class FromUser {
  final int id;
  final String image;
  final int activeUser;
  final String name;
  final String phone;
  final String email;
  final String lastOnlineTime;
  final String address;
  final String? aboutUs;
  final String verifiedBy;
  final int sendEmail;
  final String password;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  FromUser({
    required this.id,
    required this.image,
    required this.activeUser,
    required this.name,
    required this.phone,
    required this.email,
    required this.lastOnlineTime,
    required this.address,
    this.aboutUs,
    required this.verifiedBy,
    required this.sendEmail,
    required this.password,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory FromUser.fromJson(Map<String, dynamic> json) {
    return FromUser(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      activeUser: json['activeUser'] ?? 0,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      lastOnlineTime: json['last_online_time'] ?? '',
      address: json['address'] ?? '',
      aboutUs: json['aboutUs'],
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
