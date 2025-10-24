/// Notification Model for user notifications
library;

import 'dart:convert';
import 'package:rent/constants/api_endpoints.dart';
import 'package:rent/constants/images.dart';
import 'user_model.dart';

class NotificationModel {
  final int id;
  final int from;
  final int to;
  final String title;
  final String description;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserModel? fromUser; // User who sent the notification

  NotificationModel({
    this.id = 0,
    this.from = 0,
    this.to = 0,
    this.title = '',
    this.description = '',
    this.createdAt,
    this.updatedAt,
    this.fromUser,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? 0,
      from: json['from'] ?? 0,
      to: json['to'] ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['desc']?.toString() ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
      fromUser: json['fromuid'] != null
          ? UserModel.fromJson(json['fromuid'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'from': from,
      'to': to,
      'title': title,
      'desc': description,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'fromuid': fromUser?.toJson(),
    };
  }

  /// Get display title with fallback
  String get displayTitle => title.isNotEmpty ? title : 'No Title';

  /// Get short description for previews
  String get shortDescription {
    if (description.isEmpty) return 'No description available';
    // Remove HTML tags for preview
    final cleanText = description.replaceAll(RegExp(r'<[^>]*>'), '');
    return cleanText.length > 100
        ? '${cleanText.substring(0, 100)}...'
        : cleanText;
  }

  /// Get formatted created date
  String get formattedCreatedDate {
    if (createdAt == null) return '';
    final now = DateTime.now();
    final difference = now.difference(createdAt!);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  /// Check if notification is recent (within last 24 hours)
  bool get isRecent {
    if (createdAt == null) return false;
    final now = DateTime.now();
    final difference = now.difference(createdAt!);
    return difference.inHours < 24;
  }

  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, from: $from)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
