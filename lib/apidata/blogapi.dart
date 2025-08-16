import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/constants/toast.dart';

// ✅ Provider for Blogs
final blogDataProvider = ChangeNotifierProvider<BlogData>((ref) => BlogData());

class BlogData with ChangeNotifier {
  List<dynamic> blogs = [];
  Map<String, dynamic> blogDetails = {};

  // Loading state
  String loadingFor = "";
  bool isLoading = false;

  void setLoading(bool value, [String loadingName = ""]) {
    loadingFor = loadingName;
    isLoading = value;
    notifyListeners();
  }

  /// ✅ Fetch All Blogs
  Future<void> fetchAllBlogs({
    String loadingFor = "",
    String search = "",
  }) async {
    try {
      print("Fetching all blogs...");

      setLoading(true, loadingFor);
      final response = await http.get(
        Uri.parse("https://thelocalrent.com/api/allblogs"),
      );

      final data = jsonDecode(response.body);

      print("👉 Response status: ${response.statusCode}");
      print("👉 Data: $data");

      if (response.statusCode == 200) {
        blogs.clear();
        blogs = data['blogs'] ?? []; // ✅ API ke response ke hisaab se
        print("👉 Blogs loaded: ${blogs.length} items");
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

  /// ✅ Fetch Blog Details by ID
  Future<void> fetchBlogDetails({
    required String blogId,
    String loadingFor = "",
  }) async {
    try {
      print("Fetching blog details for ID: $blogId");

      setLoading(true, loadingFor);
      final response = await http.get(
        Uri.parse("https://thelocalrent.com/api/blogdetails/$blogId"),
      );

      final data = jsonDecode(response.body);

      print("👉 Response status: ${response.statusCode}");
      print("👉 Data: $data");

      if (response.statusCode == 200) {
        blogDetails = data['blog'] ?? data['blogDetails'] ?? data['data'] ?? {};
        print("👉 Blog details loaded");
        setLoading(false);
        notifyListeners();
      } else {
        toast(data['message'] ?? data['msg'] ?? 'Failed to fetch blog details');
        setLoading(false);
      }
    } catch (e) {
      setLoading(false);
      debugPrint("Error fetching blog details: $e");
    }
  }
}
