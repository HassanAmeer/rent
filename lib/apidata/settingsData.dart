import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/constants/api_endpoints.dart';
import 'package:rent/constants/checkInternet.dart';
import 'package:rent/services/goto.dart';
import 'package:rent/services/toast.dart';
import 'package:rent/design/home_page.dart';
import 'package:rent/services/cache_service.dart';

import '../models/docModel.dart';

// import '../main.dart';

final settingsProvider = ChangeNotifierProvider<SettingsDataClass>(
  (ref) => SettingsDataClass(),
);

class SettingsDataClass with ChangeNotifier {
  //////
  String loadingFor = "";
  setLoading([String value = ""]) {
    loadingFor = value;
    notifyListeners();
  }

  List settingsData = [];
  Future getSettingsData({
    required String uid,
    String loadingFor = "",
    bool refresh = false,
  }) async {
    try {
      const cacheKey = 'settings_data';

      // ✅ Load from cache first
      final cachedData = CacheService.getCache(cacheKey);
      if (cachedData != null &&
          cachedData is Map &&
          cachedData['settings'] != null) {
        settingsData = cachedData['settings'];
        notifyListeners();
        debugPrint('📦 Settings data loaded from cache');

        if (!refresh &&
            !CacheService.isCacheStale(cacheKey, maxAgeMinutes: 120)) {
          return;
        }
      } else {
        setLoading(loadingFor);
      }

      if (await checkInternet() == false) {
        if (cachedData == null) setLoading();
        return;
      }

      final response = await http.get(Uri.parse(Api.settingsEndpoint));

      var result = json.decode(response.body);
      debugPrint("👉 Response: $result");

      if (response.statusCode == 200 || response.statusCode == 201) {
        await CacheService.saveCache(cacheKey, result);
        settingsData = result['settings'];
      } else {
        toast(result['msg'], backgroundColor: Colors.red);
      }
      setLoading();
    } catch (e, st) {
      debugPrint("💥 getSettingsData: error: $e, st$st");
      setLoading();
    } finally {
      setLoading();
    }
  }
  ////////////

  DocDataModel docData = DocDataModel(
    id: 00,
    privacyPolicy: "Not Found",
    shippingPolicy: "Not Found",
    returnRefundPolicy: "Not Found",
    termsCondition: "Not Found",
    contactUs: "Not Found",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  Future getDocData({String loadingFor = ""}) async {
    try {
      const cacheKey = 'docs_data';

      // ✅ Load from cache first
      final cachedData = CacheService.getCache(cacheKey);
      if (cachedData != null &&
          cachedData is Map &&
          cachedData['data'] != null) {
        docData = DocDataModel.fromJson(cachedData['data']);
        notifyListeners();
        debugPrint('📦 Docs data loaded from cache');

        if (!CacheService.isCacheStale(cacheKey, maxAgeMinutes: 1440)) {
          // 24 hours
          return;
        }
      } else if (docData.id != 00) {
        return; // Already loaded
      } else {
        setLoading(loadingFor);
      }

      if (await checkInternet() == false) {
        if (cachedData == null) setLoading();
        return;
      }

      final response = await http.get(Uri.parse(Api.docEndpoint));

      var result = json.decode(response.body);
      debugPrint("👉 Response: $result");

      if (response.statusCode == 200 || response.statusCode == 201) {
        await CacheService.saveCache(cacheKey, result);
        docData = DocDataModel.fromJson(result['data']);
      } else {
        toast(result['msg'], backgroundColor: Colors.red);
      }
      setLoading();
    } catch (e, st) {
      debugPrint("💥 getDocData: error: $e, st$st");
      setLoading();
    } finally {
      setLoading();
    }
  }
}
