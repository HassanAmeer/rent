import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/Auth/login.dart';
import 'package:rent/Auth/profile_update_page.dart';
import 'package:rent/constants/goto.dart';
import 'package:rent/constants/toast.dart';
import 'package:rent/design/booking/my_booking_page.dart';
import 'package:rent/design/home_page.dart';

// import '../main.dart';

// Use the correct class name in the provider
final getAllItems = ChangeNotifierProvider<GetAllItems>((ref) => GetAllItems());

class GetAllItems with ChangeNotifier {
  var allItems = [];
  var order = [];
  //////
  bool isLoading = false;
  setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  fetchAllItems() async {
    try {
      setLoading(true);
      final response = await http.get(
        Uri.parse("https://thelocalrent.com/api/allitems"),
      );

      final data = jsonDecode(response.body);

      print("👉Response status: ${response.statusCode}");
      print("👉 data: $data");
      if (response.statusCode == 200) {
        allItems.clear();
        allItems = data['items'] ?? [];

        setLoading(false);
      } else {
        toast(data['msg']);
      }
      setLoading(false);
    } catch (e) {
      setLoading(false);
      print("Error fetching my items: $e");
    }
  }

  List orderedItems = [];

  /// ✅ Place Order
  Future<void> orderitems({
    required String userId,
    required String itemId,
    var availablityRange,
    String loadingFor = "",
    required BuildContext context,
  }) async {
    try {
      setLoading(true);

      final response = await http.post(
        Uri.parse("https://thelocalrent.com/api/addorder"),
        body: {
          "uid": userId,
          "productId ": itemId,
          'userCanPickupInDateRange': true,
        },
      );

      final data = jsonDecode(response.body);

      print("👉 Response status: ${response.statusCode}");
      print("👉 data: $data");

      if (response.statusCode == 200) {
        // Add item to ordered list
        if (!orderedItems.contains(itemId)) {
          orderedItems.add(itemId);
        }

        toast(data['success'] ?? "Order placed successfully ✅");

        // Wait a bit then navigate to MyBookingPage
        await Future.delayed(const Duration(milliseconds: 1000));
        goto(const MyBookingPage());
      } else {
        toast(data['msg'] ?? "Failed to place order ❌");
      }

      setLoading(false);
    } catch (e) {
      setLoading(false);
      print("❌ Error placing order: $e");
      toast("Something went wrong!");
    }
  }
}
