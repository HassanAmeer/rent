import 'package:flutter/material.dart';
import 'package:rent/main.dart';
import 'package:rent/messege.dart';

import '../constants/goto.dart';
import '../design/home_page.dart';
import '../design/listing/listing_page.dart';
import '../design/booking/my_booking_page.dart';
import '../Auth/profile_details_page.dart';

// ignore: must_be_immutable
class BottomNavBarWidget extends StatefulWidget {
  int currentIndex = 0;
  BottomNavBarWidget({super.key, this.currentIndex = 0});

  @override
  State<BottomNavBarWidget> createState() => _BottomNavBarWidgetState();
}

class _BottomNavBarWidgetState extends State<BottomNavBarWidget> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      onTap: (index) {
        if (index == 0) {
          goto(HomePage());
        } else if (index == 1) {
          goto(ListingPage());
        } else if (index == 2) {
          goto(MyBookingPage());
        } else if (index == 3) {
          goto((MessagesHome()));
        } else if (index == 4) {
          print("fdij");
          goto(ProfileDetailsPage());
        }
      },
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: 'My Listings'),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'My Bookings',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
