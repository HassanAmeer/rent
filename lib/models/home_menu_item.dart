import 'package:flutter/material.dart';

/// Model for home menu items
class HomeMenuItem {
  final String id;
  final String label;
  final IconData icon;
  final String routeName;
  final Widget? page;
  int order;

  HomeMenuItem({
    required this.id,
    required this.label,
    required this.icon,
    required this.routeName,
    this.page,
    this.order = 0,
  });

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'iconCodePoint': icon.codePoint,
      'iconFontFamily': icon.fontFamily,
      'routeName': routeName,
      'order': order,
    };
  }

  // Create from JSON
  factory HomeMenuItem.fromJson(Map<String, dynamic> json) {
    // try to find matching predefined option first to get the const IconData
    final id = json['id'] ?? '';
    final predefined = AvailableMenuOptions.getById(id);

    // If predefined found, use its icon.
    // Fallback to a default constant icon to satisfy tree-shaking.
    final iconData = predefined?.icon ?? Icons.grid_view;

    return HomeMenuItem(
      id: id,
      label: json['label'] ?? '',
      icon: iconData,
      routeName: json['routeName'] ?? '',
      order: json['order'] ?? 0,
    );
  }

  HomeMenuItem copyWith({
    String? id,
    String? label,
    IconData? icon,
    String? routeName,
    Widget? page,
    int? order,
  }) {
    return HomeMenuItem(
      id: id ?? this.id,
      label: label ?? this.label,
      icon: icon ?? this.icon,
      routeName: routeName ?? this.routeName,
      page: page ?? this.page,
      order: order ?? this.order,
    );
  }
}

/// Available menu options
class AvailableMenuOptions {
  static final List<HomeMenuItem> options = [
    HomeMenuItem(
      id: 'favorites',
      label: 'My Favorities',
      icon: Icons.bookmark_border,
      routeName: 'favorites',
    ),
    HomeMenuItem(
      id: 'rent_outs',
      label: 'Rent Outs',
      icon: Icons.calendar_month_outlined,
      routeName: 'rent_outs',
    ),
    HomeMenuItem(
      id: 'rent_in',
      label: 'Rent In',
      icon: Icons.pending_actions_outlined,
      routeName: 'rent_in',
    ),
    HomeMenuItem(
      id: 'my_listings',
      label: 'My Listings',
      icon: Icons.list_alt,
      routeName: 'my_listings',
    ),
    HomeMenuItem(
      id: 'all_items',
      label: 'All Items',
      icon: Icons.grid_view,
      routeName: 'all_items',
    ),
    HomeMenuItem(
      id: 'blogs',
      label: 'Blogs',
      icon: Icons.article_outlined,
      routeName: 'blogs',
    ),
    HomeMenuItem(
      id: 'messages',
      label: 'Messages',
      icon: Icons.message_outlined,
      routeName: 'messages',
    ),
    HomeMenuItem(
      id: 'notifications',
      label: 'Notifications',
      icon: Icons.notifications_outlined,
      routeName: 'notifications',
    ),
    HomeMenuItem(
      id: 'help',
      label: 'Help & support',
      icon: Icons.support_agent,
      routeName: 'help',
    ),
    HomeMenuItem(
      id: 'settings',
      label: 'Settings',
      icon: Icons.settings_outlined,
      routeName: 'settings',
    ),
    HomeMenuItem(
      id: 'profile',
      label: 'My Profile',
      icon: Icons.person_outline,
      routeName: 'profile',
    ),
  ];

  static HomeMenuItem? getById(String id) {
    try {
      return options.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }
}
