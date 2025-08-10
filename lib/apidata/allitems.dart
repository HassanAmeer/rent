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
final getAllItems = ChangeNotifierProvider<GetAllItems>((ref) => GetAllItems());

class GetAllItems with ChangeNotifier {
  var allItems = [];

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
}
