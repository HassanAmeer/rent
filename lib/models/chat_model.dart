/// Chat Model for messaging functionality
class ChatModel {
  final int id;
  final int senderId;
  final int receiverId;
  final String message;
  final String? time;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ChatModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    this.time,
    this.createdAt,
    this.updatedAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] ?? 0,
      senderId: json['senderId'] ?? json['sid'] ?? 0,
      receiverId: json['receiverId'] ?? json['rid'] ?? 0,
      message: json['message']?.toString() ?? json['msg']?.toString() ?? '',
      time: json['time']?.toString(),
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
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'time': time,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Check if message is from current user
  bool isFromUser(int currentUserId) => senderId == currentUserId;

  /// Get formatted time for display
  String get formattedTime {
    if (time != null && time!.isNotEmpty) {
      try {
        // Assuming time is in HH:mm format
        final parts = time!.split(':');
        if (parts.length == 2) {
          final hour = int.tryParse(parts[0]) ?? 0;
          final minute = int.tryParse(parts[1]) ?? 0;
          final period = hour >= 12 ? 'PM' : 'AM';
          final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
          return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
        }
      } catch (_) {}
    }

    if (createdAt != null) {
      final hour = createdAt!.hour;
      final minute = createdAt!.minute;
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
      return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
    }

    return '';
  }

  /// Get message preview for chat list
  String get messagePreview {
    return message.length > 50 ? '${message.substring(0, 50)}...' : message;
  }

  /// Check if message is empty
  bool get isEmpty => message.trim().isEmpty;

  /// Get message length
  int get messageLength => message.length;

  @override
  String toString() {
    return 'ChatModel(id: $id, senderId: $senderId, message: ${message.substring(0, message.length > 20 ? 20 : message.length)}...)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Chat User Model for chat users list
class ChatUserModel {
  final int id;
  final String name;
  final String? image;
  final String? lastMessage;
  final String? lastMessageTime;
  final int unreadCount;
  final DateTime? lastMessageDate;

  ChatUserModel({
    required this.id,
    required this.name,
    this.image,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount = 0,
    this.lastMessageDate,
  });

  factory ChatUserModel.fromJson(Map<String, dynamic> json) {
    return ChatUserModel(
      id: json['id'] ?? 0,
      name: json['name']?.toString() ?? '',
      image: json['image']?.toString(),
      lastMessage: json['lastMessage']?.toString(),
      lastMessageTime: json['lastMessageTime']?.toString(),
      unreadCount: json['unreadCount'] ?? 0,
      lastMessageDate: json['lastMessageDate'] != null
          ? DateTime.tryParse(json['lastMessageDate'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'unreadCount': unreadCount,
      'lastMessageDate': lastMessageDate?.toIso8601String(),
    };
  }

  /// Get full image URL
  String get fullImageUrl {
    if (image == null || image!.isEmpty) return '';
    return 'https://thelocalrent.com/uploads/$image';
  }

  /// Check if user has unread messages
  bool get hasUnreadMessages => unreadCount > 0;

  /// Get display name with fallback
  String get displayName => name.isNotEmpty ? name : 'Unknown User';

  /// Get last message preview
  String get lastMessagePreview {
    if (lastMessage == null || lastMessage!.isEmpty) return 'No messages yet';
    return lastMessage!.length > 30
        ? '${lastMessage!.substring(0, 30)}...'
        : lastMessage!;
  }

  @override
  String toString() {
    return 'ChatUserModel(id: $id, name: $name, unreadCount: $unreadCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatUserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
