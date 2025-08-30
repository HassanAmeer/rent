class FavoriteItemModel {
  final int? id;
  final int? favoriteBy;
  final int? itemId;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final RentalUser? rentalUser;
  final Product? product;

  FavoriteItemModel({
    this.id=0,
    this.favoriteBy=0,
    this.itemId=0,
    this.createdAt="",  
    this.updatedAt="",
    this.deletedAt="",
    required this.rentalUser,
    required this.product,
  });

  factory FavoriteItemModel.fromJson(Map<String, dynamic> json) {
    return FavoriteItemModel(
      id: json['id'] as int?,
      favoriteBy: json['favoriteBy'] as int?,
      itemId: json['itemId'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
      rentalUser: json['rentalusers'] != null
          ? RentalUser.fromJson(json['rentalusers'])
          : null,
      product: json['products'] != null
          ? Product.fromJson(json['products'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'favoriteBy': favoriteBy,
      'itemId': itemId,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'rentalusers': rentalUser?.toJson(),
      'products': product?.toJson(),
    };
  }
}

class RentalUser {
  final int? id;
  final String? image;
  final int? activeUser;
  final String? name;
  final String? phone;
  final String? email;
  final String? lastOnlineTime;
  final String? address;
  final String? aboutUs;
  final String? verifiedBy;
  final int? sendEmail;
  final String? password;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  RentalUser({
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

  factory RentalUser.fromJson(Map<String, dynamic> json) {
    return RentalUser(
      id: json['id'] as int?,
      image: json['image'] as String?,
      activeUser: json['activeUser'] as int?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      lastOnlineTime: json['last_online_time'] as String?,
      address: json['address'] as String?,
      aboutUs: json['aboutUs'] as String?,
      verifiedBy: json['verifiedBy'] as String?,
      sendEmail: json['sendEmail'] as int?,
      password: json['password'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
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

class Product {
  final int? id;
  final int? productBy;
  final String? title;
  final int? showProduct;
  final String? category;
  final String? description;
  final List<String>? images;
  final String? dailyRate;
  final String? weeklyRate;
  final String? monthlyRate;
  final String? availabilityDays;
  final String? pickupDateRange;
  final int? allowReviews;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  Product({
    this.id,
    this.productBy,
    this.title,
    this.showProduct,
    this.category,
    this.description,
    this.images,
    this.dailyRate,
    this.weeklyRate,
    this.monthlyRate,
    this.availabilityDays,
    this.pickupDateRange,
    this.allowReviews,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int?,
      productBy: json['productBy'] as int?,
      title: json['title'] as String?,
      showProduct: json['showProduct'] as int?,
      category: json['category'] as String?,
      description: json['description'] as String?,
      images: (json['images'] as List<dynamic>?)
          ?.map((item) => item as String)
          .toList(),
      dailyRate: json['dailyrate'] as String?,
      weeklyRate: json['weeklyrate'] as String?,
      monthlyRate: json['monthlyrate'] as String?,
      availabilityDays: json['availabilityDays'] as String?,
      pickupDateRange: json['pickupDateRange'] as String?,
      allowReviews: json['allowReviews'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productBy': productBy,
      'title': title,
      'showProduct': showProduct,
      'category': category,
      'description': description,
      'images': images,
      'dailyrate': dailyRate,
      'weeklyrate': weeklyRate,
      'monthlyrate': monthlyRate,
      'availabilityDays': availabilityDays,
      'pickupDateRange': pickupDateRange,
      'allowReviews': allowReviews,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
    };
  }
}
