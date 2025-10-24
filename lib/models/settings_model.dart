/// Settings Model for app configuration
library;

import 'dart:convert';

class SettingsModel {
  final String email;
  final String phone;
  final String address;
  final String website;
  final String supportHours;

  SettingsModel({
    this.email = '',
    this.phone = '',
    this.address = '',
    this.website = '',
    this.supportHours = '09:00 AM - 06:00 PM PKT (Monday to Friday)',
  });

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      website: json['website']?.toString() ?? '',
      supportHours:
          json['support_hours']?.toString() ??
          '09:00 AM - 06:00 PM PKT (Monday to Friday)',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'phone': phone,
      'address': address,
      'website': website,
      'support_hours': supportHours,
    };
  }

  /// Get formatted email for display
  String get displayEmail => email.isNotEmpty ? email : 'support@localrent.com';

  /// Get formatted phone for display
  String get displayPhone => phone.isNotEmpty ? phone : '+1-234-567-8900';

  /// Get formatted address for display
  String get displayAddress =>
      address.isNotEmpty ? address : '123 Main St, City, State 12345';

  /// Get formatted website for display
  String get displayWebsite =>
      website.isNotEmpty ? website : 'https://localrent.com';

  /// Check if email is available
  bool get hasEmail => email.isNotEmpty;

  /// Check if phone is available
  bool get hasPhone => phone.isNotEmpty;

  /// Check if address is available
  bool get hasAddress => address.isNotEmpty;

  /// Check if website is available
  bool get hasWebsite => website.isNotEmpty;

  @override
  String toString() {
    return 'SettingsModel(email: $email, phone: $phone, address: $address, website: $website, supportHours: $supportHours)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SettingsModel &&
        other.email == email &&
        other.phone == phone &&
        other.address == address &&
        other.website == website &&
        other.supportHours == supportHours;
  }

  @override
  int get hashCode {
    return email.hashCode ^
        phone.hashCode ^
        address.hashCode ^
        website.hashCode ^
        supportHours.hashCode;
  }
}
