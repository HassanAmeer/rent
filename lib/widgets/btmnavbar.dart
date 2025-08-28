import 'package:flutter/material.dart';
import 'package:rent/main.dart';
import 'package:rent/message/chatedUsersPage.dart';

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
    return WillPopScope(
      onWillPop: () {
        if(widget.currentIndex >0){
            goto(HomePage());
        }
        return Future.value(false);
      },
      child: BottomNavigationBar(
        currentIndex: widget.currentIndex,
        onTap: (index) {
          if (index == 0) {
            goto(HomePage(), canBack: false);
          } else if (index == 1) {
            goto(ListingPage(), canBack: false);
          } else if (index == 2) {
            goto(MyBookingPage(), canBack: false);
          } else if (index == 3) {
            goto((ChatedUsersPage()));
          } else if (index == 4) {
            goto(ProfileDetailsPage(), canBack: false);
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
      ),
    );
  }
}
