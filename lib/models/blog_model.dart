/// Blog Model for blog posts and articles
library;

import 'dart:convert';
import 'package:rent/constants/api_endpoints.dart';
import 'package:rent/constants/images.dart';
import 'package:rent/constants/tostring.dart';

class BlogModel {
  final int id;
  final String title;
  final String content;
  final String excerpt;
  final String image;
  final String author;
  final DateTime? publishedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<String> tags;
  final String status; // published, draft, etc.
  final int views;
  final String slug;

  BlogModel({
    this.id = 0,
    this.title = 'No Title Available',
    this.content = 'No description available',
    this.excerpt = '',
    this.image = ImgLinks.noItem,
    this.author = '',
    this.publishedAt,
    this.createdAt,
    this.updatedAt,
    this.tags = const [],
    this.status = 'draft',
    this.views = 0,
    this.slug = '',
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    List<String> parseTags(dynamic tagsData) {
      if (tagsData == null) return [];
      if (tagsData is List) {
        return tagsData.map((tag) => tag.toString()).toList();
      }
      if (tagsData is String) {
        try {
          final decoded = jsonDecode(tagsData);
          if (decoded is List) {
            return decoded.map((tag) => tag.toString()).toList();
          }
        } catch (_) {}
        return [tagsData];
      }
      return [];
    }

    return BlogModel(
      id: json['id'] ?? 1,
      title: (json['title']?.toString() ?? '').toNullStringOrDemo(
        'This Blog Title Is Empty!',
      ),
      content: (json['content']?.toString() ?? '').toNullStringOrDemo(
        'This Blog Content Is Empty!',
      ),
      excerpt: (json['excerpt']?.toString() ?? '').toNullStringOrDemo(
        'This Blog Excerpt Is Empty!',
      ),
      image: json['image'] != null && json['image'].toString().trim().isNotEmpty
          ? Api.imgPath + json['image']
          : ImgLinks.noItem,
      author: (json['author']?.toString() ?? '').toNullStringOrDemo(
        'Demo Author',
      ),
      publishedAt: json['published_at'] != null
          ? DateTime.tryParse(json['published_at'].toString())
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
      tags: parseTags(json['tags']),
      status: (json['status']?.toString() ?? '').toNullStringOrDemo('draft'),
      views: json['views'] ?? 0,
      slug: (json['slug']?.toString() ?? '').toNullStringOrDemo(
        'demo-blog-slug',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'excerpt': excerpt,
      'image': image,
      'author': author,
      'published_at': publishedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'tags': tags,
      'status': status,
      'views': views,
      'slug': slug,
    };
  }

  /// Get display title with fallback
  String get displayTitle => title.isNotEmpty ? title : 'No Title';

  /// Get short excerpt for previews
  String get shortExcerpt {
    if (excerpt.isNotEmpty) return excerpt;
    if (content.isNotEmpty) {
      return content.length > 150 ? '${content.substring(0, 150)}...' : content;
    }
    return 'No content available';
  }

  /// Check if blog is published
  bool get isPublished => status == 'published';

  /// Get formatted published date
  String get formattedPublishedDate {
    if (publishedAt == null) return '';
    return '${publishedAt!.day}/${publishedAt!.month}/${publishedAt!.year}';
  }

  /// Get reading time estimate (roughly 200 words per minute)
  int get estimatedReadingTime {
    final wordCount = content.split(RegExp(r'\s+')).length;
    return (wordCount / 200).ceil();
  }

  @override
  String toString() {
    return 'BlogModel(id: $id, title: $title, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BlogModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
