import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/constants/api_endpoints.dart';
import 'package:rent/constants/checkInternet.dart' show checkInternet;
import 'package:rent/constants/toast.dart';

// ✅ Provider for Blogs
final SupportProvider = ChangeNotifierProvider<supportData>(
  (ref) => supportData(),
);

class supportData with ChangeNotifier {
  // Loading state
  Map settings = {};

  var widget;

  String loadingFor = "";
  setLoading([String loadingName = ""]) {
    loadingFor = loadingName;
    notifyListeners();
  }

  /// ✅ Fetch All Blogs
  Future<void> contectus({var loadingFor = ""}) async {
    try {
      if (await checkInternet() == false) return;

      print("Fetching all blogs...");

      setLoading(loadingFor);
      final response = await http.get(Uri.parse(Api.settingsEndpoint));

      final data = jsonDecode(response.body);

      print("👉 Response status: ${response.statusCode}");
      print("👉 Data: $data");

      if (response.statusCode == 200) {
        settings = data['settings'] ?? {}; // ✅ API ke response ke hisaab se
        print("👉 Blogs loaded: ${settings.length} items");
        setLoading();
        notifyListeners();
      } else {
        toast(data['message'] ?? data['msg'] ?? 'Failed to fetch blogs');
        setLoading();
      }
    } catch (e) {
      setLoading();
      debugPrint("Error fetching blogs: $e");
    }
  }

  //
}
