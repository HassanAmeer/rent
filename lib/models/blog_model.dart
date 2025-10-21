/// Blog Model for blog posts and articles
class BlogModel {
  final int id;
  final String title;
  final String? description;
  final String? image;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BlogModel({
    required this.id,
    required this.title,
    this.description,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      id: json['id'] ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      image: json['image']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': image,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Get full image URL
  String get fullImageUrl {
    if (image == null || image!.isEmpty) return '';
    return 'https://thelocalrent.com/uploads/$image';
  }

  /// Check if blog has image
  bool get hasImage => image != null && image!.isNotEmpty;

  /// Get display title with fallback
  String get displayTitle => title.isNotEmpty ? title : 'Untitled Blog';

  /// Get short description for previews
  String get shortDescription {
    if (description == null || description!.isEmpty) return '';
    return description!.length > 150
        ? '${description!.substring(0, 150)}...'
        : description!;
  }

  /// Get formatted creation date
  String get formattedDate {
    if (createdAt == null) return '';
    final now = DateTime.now();
    final difference = now.difference(createdAt!);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks week${weeks > 1 ? 's' : ''} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years year${years > 1 ? 's' : ''} ago';
    }
  }

  @override
  String toString() {
    return 'BlogModel(id: $id, title: $title)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BlogModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
