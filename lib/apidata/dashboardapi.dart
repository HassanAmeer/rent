import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/constants/api_endpoints.dart';
import 'package:rent/services/toast.dart';
import 'package:rent/services/cache_service.dart';

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

  fetchDashboard({
    String loadingfor = "",
    required uid,
    bool refresh = false,
  }) async {
    try {
      final cacheKey = CacheService.generateKey('dashboard', {'uid': uid});

      // ✅ Load from cache first (instant display)
      final cachedData = CacheService.getCache(cacheKey);
      if (cachedData != null && cachedData is Map) {
        dashboardData = Map<String, dynamic>.from(cachedData);
        notifyListeners(); // Show cached data instantly!
        debugPrint('📦 Dashboard loaded from cache');

        // If not forcing refresh and have fresh cache, skip API call
        if (!refresh &&
            !CacheService.isCacheStale(cacheKey, maxAgeMinutes: 10)) {
          return;
        }
      } else {
        // No cache, show loading
        setLoading(loadingfor);
      }

      if (await checkInternet() == false) {
        if (cachedData == null) setLoading("");
        return;
      }

      // ✅ Fetch fresh data from API
      final response = await http.get(
        Uri.parse("${Api.dashboardEndpoint}$uid"),
      );

      final data = jsonDecode(response.body);
      debugPrint("👉Response status: ${response.statusCode}");
      debugPrint("👉 data: $data");

      if (response.statusCode == 200) {
        // Save to cache
        await CacheService.saveCache(cacheKey, data);

        dashboardData.clear();
        dashboardData = data;
      } else {
        toast(data['msg'] ?? "Something went wrong");
      }
      setLoading("");
    } catch (e) {
      debugPrint("❌ Error fetching dashboard: $e");
      setLoading("");
    } finally {
      setLoading("");
    }
  }
}
