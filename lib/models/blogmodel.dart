class Blogmodel {
  final int id;
  final String image;
  final String title;
  final String description;
  final String createdAt;
  final String updatedAt;

  Blogmodel({
    required this.id,
    required this.image,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Blogmodel.fromJson(Map<String, dynamic> json) {
    return Blogmodel(
      id: json['id'] ?? 0,
      image: json['image'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'title': title,
      'description': description,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
