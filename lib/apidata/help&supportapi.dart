import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/constants/api_endpoints.dart';
import 'package:rent/constants/checkInternet.dart' show checkInternet;
import 'package:rent/services/toast.dart';
import 'package:rent/models/settings_model.dart';
import 'package:rent/services/cache_service.dart';

// ✅ Provider for Blogs
final SupportProvider = ChangeNotifierProvider<supportData>(
  (ref) => supportData(),
);

class supportData with ChangeNotifier {
  // Loading state
  SettingsModel? settings;

  var widget;

  String loadingFor = "";
  setLoading([String loadingName = ""]) {
    loadingFor = loadingName;
    notifyListeners();
  }

  /// ✅ Fetch All Blogs
  Future<void> contectus({var loadingFor = ""}) async {
    try {
      const cacheKey = 'settings';

      // ✅ Load from cache first
      final cachedData = CacheService.getCache(cacheKey);
      if (cachedData != null &&
          cachedData is Map &&
          cachedData['settings'] != null) {
        final settingsData = cachedData['settings'] ?? {};
        settings = SettingsModel.fromJson(settingsData);
        notifyListeners();
        debugPrint('📦 Settings loaded from cache');

        if (!CacheService.isCacheStale(cacheKey, maxAgeMinutes: 120)) {
          return;
        }
      } else {
        setLoading(loadingFor);
      }

      if (await checkInternet() == false) {
        if (cachedData == null) setLoading();
        return;
      }

      debugPrint("Fetching all blogs...");

      final response = await http.get(Uri.parse(Api.settingsEndpoint));

      final data = jsonDecode(response.body);

      debugPrint("👉 Response status: ${response.statusCode}");
      debugPrint("👉 Data: $data");

      if (response.statusCode == 200) {
        await CacheService.saveCache(cacheKey, data);

        final settingsData = data['settings'] ?? {};
        settings = SettingsModel.fromJson(
          settingsData,
        ); // ✅ API ke response ke hisaab se
        debugPrint("👉 Settings loaded: $settings");
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
