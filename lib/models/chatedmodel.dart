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
    this.id = 0,
    this.sid = 0,
    this.msg = "",
    this.rid = 0,
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt,
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
    this.id = 0,
    this.image = "",
    this.activeUser = 0,
    this.name = "",
    this.phone = "",
    this.email = "",
    this.lastOnlineTime = "",
    this.address = "",
    this.aboutUs = "",
    this.verifiedBy = "",
    this.sendEmail = 0,
    this.password = "",
    this.createdAt = "",
    this.updatedAt = "",
    this.deletedAt = "",
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
// https://mocki.io/v1/4cb45c96-50f1-4144-ba6a-66fea7376546
// class ProductsModel {
//   final bool status;
//   final String message;
//   final List<Product> products;

//   ProductsModel({
//      this.status,
//     required this.message,
//     required this.products,
//   });

//   factory ProductsModel.fromJson(Map<String, dynamic> json) {
//     return ProductsModel(
//       status: json['status'] ?? false,
//       message: json['message'] ?? '',

// List<Product> tempList = []; // empty list banayi

// // json['products'] ko list me cast kiya
// List<dynamic> productList = json['products'] as List<dynamic>? ?? [];

// // loop lagaya har product pe
// for (var e in productList) {
//   // har ek map ko Product object banaya
//   Product product = Product.fromJson(e);

//   tempList.add(product);
// }

// products: tempList,
// class OrdersModel {
//   final bool isSuccess;
//   final String info;
//   final List<Order> orders;

//   OrdersModel({
//     required this.isSuccess,
//     required this.info,
//     required this.orders,
//   });

//   factory OrdersModel.fromJson(Map<String, dynamic> json) {
//     return OrdersModel(
//       isSuccess: json['isSuccess'] ?? false,
//       info: json['info'] ?? '',
//       orders: () {
//         List<Order> tempList = [];
//         List<dynamic> orderList = json['orders'] as List<dynamic>? ?? [];

//         for (var e in orderList) {
//           tempList.add(Order.fromJson(e));
//         }

//         return tempList;
//       }(),
//     );
//   }
// }
