import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/constants/api_endpoints.dart';
import 'package:rent/constants/checkInternet.dart';
import 'package:rent/constants/images.dart';
import 'package:rent/services/toast.dart';
import 'package:rent/models/catgModel.dart';
import 'package:rent/services/cache_service.dart';

// ✅ Provider for Categories
final categoryProvider = ChangeNotifierProvider<CategoryData>(
  (ref) => CategoryData(),
);

class CategoryData with ChangeNotifier {
  String loadingFor = "";

  void setLoading([String loadingName = ""]) {
    loadingFor = loadingName;
    notifyListeners();
  }

  /// ✅ Fetch All Categories from API
  List<CategoryModel> categories = [];
  Future<void> fetchCategories({
    String loadingFor = "",
    bool refresh = false,
  }) async {
    try {
      const cacheKey = 'categories';

      // ✅ Load from cache first (instant display)
      final cachedData = CacheService.getCache(cacheKey);
      if (cachedData != null &&
          cachedData is Map &&
          cachedData['catg'] is List) {
        categories = (cachedData['catg'] as List)
            .map((item) => CategoryModel.fromJson(item))
            .toList();
        notifyListeners(); // Show cached categories instantly!
        debugPrint(
          '📦 Categories loaded from cache: ${categories.length} items',
        );

        // If not forcing refresh and have fresh cache, skip API call
        if (!refresh &&
            !CacheService.isCacheStale(cacheKey, maxAgeMinutes: 60)) {
          return;
        }
      } else {
        // No cache, show loading
        setLoading(loadingFor);
      }

      if (await checkInternet() == false) {
        if (cachedData == null) setLoading();
        return;
      }

      // ✅ Fetch fresh data from API
      final response = await http.get(Uri.parse(Api.getCatgEndpoint));
      final data = jsonDecode(response.body);
      debugPrint("👉 Response status: ${response.statusCode}");
      debugPrint("👉 Data: $data");

      if (response.statusCode == 200) {
        // Save to cache
        await CacheService.saveCache(cacheKey, data);

        categories.clear();
        if (data['catg'] != null && data['catg'] is List) {
          categories = (data['catg'] as List)
              .map((item) => CategoryModel.fromJson(item))
              .toList();
        }
        debugPrint("👉 Categories loaded: ${categories.length} items");
        setLoading();
        notifyListeners();
      } else {
        toast(data['msg'] ?? 'Failed to fetch categories');
        setLoading();
      }
    } catch (e) {
      setLoading();
      debugPrint("Error fetching categories: $e");
      toast("Error fetching categories: ${e.toString()}");
    }
  }

  /// ✅ Get category by ID
  CategoryModel? getCategoryById(int id) {
    try {
      return categories.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  /// ✅ Get category by name
  CategoryModel? getCategoryByName(String name) {
    try {
      return categories.firstWhere(
        (cat) => cat.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  /// ✅ Get category names list (for dropdowns)
  List<String> get categoryNames {
    return categories.map((cat) => cat.name).toList();
  }

  /// ✅ Get categories as dropdown items
  List<DropdownMenuItem<String>> get dropdownItems {
    return categories.map((cat) {
      return DropdownMenuItem<String>(value: cat.name, child: Text(cat.name));
    }).toList();
  }
}
