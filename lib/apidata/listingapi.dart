import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/Auth/login.dart';
import 'package:rent/Auth/profile_update_page.dart';
import 'package:rent/auth/profile_details_page.dart';
import 'package:rent/constants/goto.dart';
import 'package:rent/constants/toast.dart';
import 'package:rent/home_page.dart';

import '../main.dart';

// Use the correct class name in the provider
final listingDataProvider = ChangeNotifierProvider<ListingData>(
  (ref) => ListingData(),
);

class ListingData with ChangeNotifier {
  var listings = [];

  //////
  bool isLoading = false;
  setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  fetchMyItems({required String uid}) async {
    try {
      print("Fetching my items for user ID: $uid");
      final response = await http.get(
        Uri.parse("https://thelocalrent.com/api/myitems/$uid"),
      );

      final data = jsonDecode(response.body);

      print("👉Response status: ${response.statusCode}");
      print("👉 data: ${data}");
      if (response.statusCode == 200) {
        listings = data['items'] ?? [];
        // listings =  [];

        notifyListeners();
      } else {
        toast(data['msg']);
      }
    } catch (e) {
      print("Error fetching my items: $e");
    }
  }

  editsmyitems({required String itemId, required String uid}) async {
    try {
      final response = await http.put(
        Uri.parse("https://thelocalrent.com/api/myitems/$itemId"),
        body: {"key": "values"},
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        fetchMyItems(uid: uid);
        toast(data["msg"], backgroundColor: Colors.green);
      } else {
        toast(data["msg"], backgroundColor: Colors.red);
      }
    } catch (e) {
      print("errore$e");
    }
  }

  //
}
