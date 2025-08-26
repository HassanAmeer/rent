import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/constants/toast.dart';

import '../constants/checkInternet.dart';

// ✅ Provider create karte hain
final dashboardProvider = ChangeNotifierProvider<DashboardService>(
  (ref) => DashboardService(),
);

class DashboardService with ChangeNotifier {
  Map<String, dynamic> dashboardData = {};
  String loadingfor = "";

  // ✅ Direct keys for quick access
  String name = "";
  String email = "";
  String password = "";

  // ✅ Loader set karne ka function
  setLoading([String value = ""]) {
    loadingfor = value;
    notifyListeners();
  }

  // ✅ Loader set karne ka function

  Loading([String value = ""]) {
    loadingfor = value;
    notifyListeners();
  }

  fetchDashboard({String loadingfor = "", required uid}) async {
    try {
      setLoading(loadingfor);

      final response = await http.get(
        Uri.parse("https://thelocalrent.com/api/dashboard/$uid"),
      );

      final data = jsonDecode(response.body);
      print("👉Response status: ${response.statusCode}");
      print("👉 data: $data");

      if (response.statusCode == 200) {
        dashboardData.clear();
        dashboardData = data;
      } else {
        toast(data['msg'] ?? "Something went wrong");
      }
      setLoading("");
    } catch (e) {
      print("❌ Error fetching dashboard: $e");
      setLoading("");
    } finally {
      setLoading("");
    }
  }
}
