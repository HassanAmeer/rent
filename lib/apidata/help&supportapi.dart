import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/constants/toast.dart';

// ✅ Provider for Blogs
final SupportProvider = ChangeNotifierProvider<supportData>(
  (ref) => supportData(),
);

class supportData with ChangeNotifier {
  // Loading state
  var settings;
  String loadingFor = "";
  bool isLoading = false;

  var widget;

  void setLoading(bool value, [String loadingName = ""]) {
    loadingFor = loadingName;
    isLoading = value;
    notifyListeners();
  }

  /// ✅ Fetch All Blogs
  Future<void> contectus() async {
    try {
      print("Fetching all blogs...");

      setLoading(true, loadingFor);
      final response = await http.get(
        Uri.parse("https://thelocalrent.com/api/settings"),
      );

      final data = jsonDecode(response.body);

      print("👉 Response status: ${response.statusCode}");
      print("👉 Data: $data");

      if (response.statusCode == 200) {
        settings = data['settings'] ?? []; // ✅ API ke response ke hisaab se
        print("👉 Blogs loaded: ${settings.length} items");
        setLoading(false);
        notifyListeners();
      } else {
        toast(data['message'] ?? data['msg'] ?? 'Failed to fetch blogs');
        setLoading(false);
      }
    } catch (e) {
      setLoading(false);
      debugPrint("Error fetching blogs: $e");
    }
  }

  //
}
