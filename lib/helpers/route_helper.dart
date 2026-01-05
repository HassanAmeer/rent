import 'package:flutter/material.dart';
import 'package:rent/design/all%20items/allitems.dart';
import 'package:rent/design/blogs/blogs.dart';
import 'package:rent/design/fav/fav_items.dart';
import 'package:rent/design/help.dart';
import 'package:rent/design/listing/listing_page.dart';
import 'package:rent/design/message/chatedUsersPage.dart';
import 'package:rent/design/notify/notificationpage.dart';
import 'package:rent/design/rentin/rent_in_page.dart';
import 'package:rent/design/rentout/rent_out_page.dart';
import 'package:rent/design/auth/profile_details_page.dart';

class RouteHelper {
  /// Get widget page from route name
  static Widget? getPageFromRoute(String routeName) {
    switch (routeName) {
      case 'favorites':
        return const Favourite();
      case 'rent_outs':
        return const RentOutPage();
      case 'rent_in':
        return const RentInPage();
      case 'my_listings':
        return const ListingPage();
      case 'all_items':
        return const AllItemsPage();
      case 'blogs':
        return const Blogs();
      case 'messages':
        return const ChatedUsersPage();
      case 'notifications':
        return const NotificationPage();
      case 'help':
        return const Help();
      case 'settings':
        return const Help(); // Using Help page as placeholder
      case 'profile':
        return const ProfileDetailsPage();
      default:
        return null;
    }
  }
}
