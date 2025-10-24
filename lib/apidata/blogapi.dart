import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/constants/api_endpoints.dart';
import 'package:rent/constants/checkInternet.dart';
import 'package:rent/constants/toast.dart';
import 'package:rent/models/blog_model.dart';

// ✅ Provider for Blogs
final blogDataProvider = ChangeNotifierProvider<BlogData>((ref) => BlogData());

class BlogData with ChangeNotifier {
  List<BlogModel> blogs = [];
  BlogModel? blogDetails;

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
      if (await checkInternet() == false) return;

      print("Fetching all blogs...");

      setLoading(true, loadingFor);
      final response = await http.get(Uri.parse(Api.allBlogsEndpoint));

      final data = jsonDecode(response.body);

      print("👉 Response status: ${response.statusCode}");
      print("👉 Data: $data");

      if (response.statusCode == 200) {
        blogs.clear();
        final blogsData = data['blogs'] ?? [];
        blogs = blogsData
            .map<BlogModel>((blog) => BlogModel.fromJson(blog))
            .toList();
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
      if (await checkInternet() == false) return;

      print("Fetching blog details for ID: $blogId");

      setLoading(true, loadingFor);
      final response = await http.get(
        Uri.parse("${Api.blogDetailsEndpoint}$blogId"),
      );

      final data = jsonDecode(response.body);

      print("👉 Response status: ${response.statusCode}");
      print("👉 Data: $data");

      if (response.statusCode == 200) {
        final blogData =
            data['blog'] ?? data['blogDetails'] ?? data['data'] ?? {};
        blogDetails = BlogModel.fromJson(blogData);
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
