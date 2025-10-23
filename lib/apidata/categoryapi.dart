import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/constants/checkInternet.dart';
import 'package:rent/constants/toast.dart';
import 'package:rent/models/catgModel.dart';

// ✅ Provider for Categories
final categoryProvider = ChangeNotifierProvider<CategoryData>(
  (ref) => CategoryData(),
);

class CategoryData with ChangeNotifier {
  List<CategoryModel> categories = [];
  String loadingFor = "";
  bool _hasLoaded = false; // Track if data has been loaded

  void setLoading(bool value, [String loadingName = ""]) {
    loadingFor = loadingName;
    notifyListeners();
  }

  // Check if categories are already loaded
  bool get hasLoaded => _hasLoaded && categories.isNotEmpty;

  /// ✅ Fetch All Categories from API
  Future<void> fetchCategories({String loadingFor = ""}) async {
    try {
      if (await checkInternet() == false) return;

      print("Fetching categories from API...");

      setLoading(true, loadingFor);
      final response = await http.get(
        Uri.parse("https://thelocalrent.com/api/getcatg"),
      );

      final data = jsonDecode(response.body);

      print("👉 Response status: ${response.statusCode}");
      print("👉 Data: $data");

      if (response.statusCode == 200) {
        categories.clear();
        if (data['categories'] != null && data['categories'] is List) {
          categories = (data['categories'] as List)
              .map((item) => CategoryModel.fromJson(item))
              .toList();
        }
        print("👉 Categories loaded: ${categories.length} items");
        _hasLoaded = true; // Mark as loaded
        setLoading(false);
        notifyListeners();
      } else {
        toast(data['message'] ?? data['msg'] ?? 'Failed to fetch categories');
        setLoading(false);
      }
    } catch (e) {
      setLoading(false);
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

  /// ✅ Fetch categories only if not already loaded
  Future<void> fetchCategoriesIfNeeded({String loadingFor = ""}) async {
    if (!hasLoaded) {
      await fetchCategories(loadingFor: loadingFor);
    }
  }

  /// ✅ Force refresh categories
  Future<void> refreshCategories({String loadingFor = ""}) async {
    _hasLoaded = false; // Reset flag to force reload
    await fetchCategories(loadingFor: loadingFor);
  }
}
