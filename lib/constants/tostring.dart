import 'package:intl/intl.dart';

/// Enhanced string utilities with better null safety and formatting
extension StringExtensions on String? {
  /// Returns empty string if null, empty, or "null"
  String toNullString() {
    if (this == null ||
        this!.trim().isEmpty ||
        this!.trim().toLowerCase() == "null") {
      return "";
    }
    return this!;
  }

  /// Capitalizes the first letter of the string
  String capitalize() {
    if (this == null || this!.isEmpty) return "";
    return "${this![0].toUpperCase()}${this!.substring(1).toLowerCase()}";
  }

  /// Capitalizes the first letter of each word
  String capitalizeWords() {
    if (this == null || this!.isEmpty) return "";
    return this!.split(' ').map((word) => word.capitalize()).join(' ');
  }

  /// Truncates string to specified length with ellipsis
  String truncate(int maxLength, {String suffix = "..."}) {
    if (this == null || this!.length <= maxLength) return this ?? "";
    return "${this!.substring(0, maxLength)}$suffix";
  }

  /// Checks if string is a valid email
  bool isValidEmail() {
    if (this == null) return false;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this!);
  }

  /// Checks if string is a valid phone number (basic validation)
  bool isValidPhone() {
    if (this == null) return false;
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{10,}$');
    return phoneRegex.hasMatch(this!);
  }

  /// Converts string to double safely
  double? toDoubleOrNull() {
    if (this == null) return null;
    return double.tryParse(this!);
  }

  /// Converts string to int safely
  int? toIntOrNull() {
    if (this == null) return null;
    return int.tryParse(this!);
  }

  /// Removes all whitespace
  String removeWhitespace() {
    if (this == null) return "";
    return this!.replaceAll(RegExp(r'\s+'), '');
  }

  /// Formats string as currency
  String toCurrency({String symbol = '\$', int decimalDigits = 2}) {
    if (this == null) return "";
    final value = double.tryParse(this!);
    if (value == null) return this!;

    final formatter = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: decimalDigits,
    );
    return formatter.format(value);
  }
}

/// Enhanced int utilities
extension IntExtensions on int? {
  /// Returns 0 if null or negative
  int toNullInt() {
    if (this == null || this! <= 0) {
      return 0;
    }
    return this!;
  }

  /// Converts to ordinal string (1st, 2nd, 3rd, etc.)
  String toOrdinal() {
    if (this == null) return "";
    final number = this!;
    if (number % 100 >= 11 && number % 100 <= 13) {
      return "${number}th";
    }
    switch (number % 10) {
      case 1:
        return "${number}st";
      case 2:
        return "${number}nd";
      case 3:
        return "${number}rd";
      default:
        return "${number}th";
    }
  }

  /// Formats as file size (bytes, KB, MB, GB)
  String toFileSize() {
    if (this == null) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var size = this!.toDouble();
    var i = 0;
    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }
    return "${size.toStringAsFixed(1)} ${suffixes[i]}";
  }
}

/// Enhanced double utilities
extension DoubleExtensions on double? {
  /// Returns 0.0 if null or negative
  double toNullDouble() {
    if (this == null || this! <= 0) {
      return 0.0;
    }
    return this!;
  }

  /// Rounds to specified decimal places
  double roundTo(int decimalPlaces) {
    if (this == null) return 0.0;
    final mod = (10.0 * decimalPlaces);
    return (this! * mod).roundToDouble() / mod;
  }

  /// Converts to percentage string
  String toPercentage({int decimalDigits = 1}) {
    if (this == null) return "0%";
    return "${(this! * 100).toStringAsFixed(decimalDigits)}%";
  }
}

/// Enhanced DateTime utilities
extension DateTimeExtensions on DateTime? {
  /// Formats to readable string
  String toReadableString() {
    if (this == null) return "";
    return DateFormat('MMM dd, yyyy').format(this!);
  }

  /// Formats to time string
  String toTimeString() {
    if (this == null) return "";
    return DateFormat('hh:mm a').format(this!);
  }

  /// Formats to full date and time string
  String toFullDateTimeString() {
    if (this == null) return "";
    return DateFormat('MMM dd, yyyy hh:mm a').format(this!);
  }

  /// Checks if date is today
  bool isToday() {
    if (this == null) return false;
    final now = DateTime.now();
    return this!.year == now.year &&
        this!.month == now.month &&
        this!.day == now.day;
  }

  /// Checks if date is yesterday
  bool isYesterday() {
    if (this == null) return false;
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return this!.year == yesterday.year &&
        this!.month == yesterday.month &&
        this!.day == yesterday.day;
  }

  /// Gets relative time string (e.g., "2 hours ago")
  String toRelativeTime() {
    if (this == null) return "";
    final now = DateTime.now();
    final difference = now.difference(this!);

    if (difference.inDays > 365) {
      return "${(difference.inDays / 365).floor()} years ago";
    } else if (difference.inDays > 30) {
      return "${(difference.inDays / 30).floor()} months ago";
    } else if (difference.inDays > 0) {
      return "${difference.inDays} days ago";
    } else if (difference.inHours > 0) {
      return "${difference.inHours} hours ago";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes} minutes ago";
    } else {
      return "Just now";
    }
  }
}
