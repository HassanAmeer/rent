/// Notification Model for user notifications
library;

import 'user_model.dart';

class NotificationModel {
  final int id;
  final int from;
  final int to;
  final String title;
  final String? desc;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserModel? fromUser;

  NotificationModel({
    required this.id,
    required this.from,
    required this.to,
    required this.title,
    this.desc,
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
      desc: json['desc']?.toString(),
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
      'desc': desc,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'fromuid': fromUser?.toJson(),
    };
  }

  /// Get formatted creation date
  String get formattedDate {
    if (createdAt == null) return '';
    final now = DateTime.now();
    final difference = now.difference(createdAt!);

    if (difference.inDays == 0) {
      final hours = difference.inHours;
      if (hours == 0) {
        final minutes = difference.inMinutes;
        return minutes == 0
            ? 'Just now'
            : '$minutes minute${minutes > 1 ? 's' : ''} ago';
      }
      return '$hours hour${hours > 1 ? 's' : ''} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${createdAt!.day}/${createdAt!.month}/${createdAt!.year}';
    }
  }

  /// Get notification type based on title
  String get notificationType {
    if (title.toLowerCase().contains('booking')) return 'booking';
    if (title.toLowerCase().contains('rental')) return 'rental';
    if (title.toLowerCase().contains('message')) return 'message';
    return 'general';
  }

  /// Get notification icon based on type
  String get iconName {
    switch (notificationType) {
      case 'booking':
        return 'event_available';
      case 'rental':
        return 'shopping_cart';
      case 'message':
        return 'message';
      default:
        return 'notifications';
    }
  }

  /// Check if notification is recent (within 24 hours)
  bool get isRecent {
    if (createdAt == null) return false;
    final difference = DateTime.now().difference(createdAt!);
    return difference.inHours < 24;
  }

  /// Get display title
  String get displayTitle => title.isNotEmpty ? title : 'Notification';

  /// Get short description for previews
  String get shortDescription {
    if (desc == null || desc!.isEmpty) return '';
    // Remove HTML tags for preview
    final cleanDesc = desc!.replaceAll(RegExp(r'<[^>]*>'), '');
    return cleanDesc.length > 100
        ? '${cleanDesc.substring(0, 100)}...'
        : cleanDesc;
  }

  @override
  String toString() {
    return 'NotificationModel(id: $id, title: $title, type: $notificationType)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NotificationModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
