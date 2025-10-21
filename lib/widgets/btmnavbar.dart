import 'package:flutter/material.dart';
import 'package:rent/main.dart';
import 'package:rent/message/chatedUsersPage.dart';

import '../constants/appColors.dart';
import '../constants/goto.dart';
import '../design/home_page.dart';
import '../design/listing/listing_page.dart';
import '../design/booking/my_booking_page.dart';
import '../Auth/profile_details_page.dart';

/// Enhanced Bottom Navigation Bar Widget with better error handling and customization
class BottomNavBarWidget extends StatefulWidget {
  final int currentIndex;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final bool showUnselectedLabels;
  final BottomNavigationBarType type;
  final List<BottomNavigationBarItem> items;

  const BottomNavBarWidget({
    super.key,
    this.currentIndex = 0,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.showUnselectedLabels = true,
    this.type = BottomNavigationBarType.fixed,
    this.items = const [],
  });

  @override
  State<BottomNavBarWidget> createState() => _BottomNavBarWidgetState();
}

class _BottomNavBarWidgetState extends State<BottomNavBarWidget> {
  /// Default navigation items if none provided
  static const List<BottomNavigationBarItem> _defaultItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.list), label: 'My Listings'),
    BottomNavigationBarItem(
      icon: Icon(Icons.calendar_today),
      label: 'My Bookings',
    ),
    BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
    BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
  ];

  /// Handle navigation tap with error handling
  void _onItemTapped(int index) {
    try {
      switch (index) {
        case 0:
          goto(const HomePage(), canBack: false);
          break;
        case 1:
          goto(const ListingPage(), canBack: false);
          break;
        case 2:
          goto(const MyBookingPage(), canBack: false);
          break;
        case 3:
          goto(const ChatedUsersPage(), canBack: false);
          break;
        case 4:
          goto(const ProfileDetailsPage(), canBack: false);
          break;
        default:
          debugPrint("Invalid navigation index: $index");
      }
    } catch (e) {
      debugPrint("Navigation error: $e");
    }
  }

  /// Handle back press with improved logic
  Future<bool> _onWillPop() async {
    if (widget.currentIndex > 0) {
      goto(const HomePage(), canBack: false);
      return false; // Don't exit app, navigate to home
    }
    return true; // Exit app
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: _onItemTapped,
        selectedItemColor: widget.selectedItemColor ?? AppColors.btnBgColor,
        unselectedItemColor: widget.unselectedItemColor ?? Colors.grey,
        showUnselectedLabels: widget.showUnselectedLabels,
        type: widget.type,
        backgroundColor: Colors.white,
        elevation: 8,
        items: widget.items.isNotEmpty ? widget.items : _defaultItems,
      ),
    );
  }
}
