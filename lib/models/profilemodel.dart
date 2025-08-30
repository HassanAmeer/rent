class ProfileModel {
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

  ProfileModel({
    this.id = 00,
    this.image =
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQi50zTLuADwdCHUNWNkOxgIh05Uo3ma8euw&s",
    this.activeUser = 1,
    this.name = "",
    this.phone = "",
    this.email = "",
    this.lastOnlineTime = "",
    this.address = "",
    this.aboutUs,
    this.verifiedBy = "",
    this.sendEmail = 0,
    this.password = "",
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt,
  });

  // ✅ JSON → Model
  factory ProfileModel.fromJson(Map json) {
    return ProfileModel(
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

  // ✅ Model → JSON
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
