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

  void setLoading([String loadingName = ""]) {
    loadingFor = loadingName;
    notifyListeners();
  }

  /// ✅ Fetch All Blogs
  Future<void> fetchAllBlogs({
    String loadingFor = "",
    String search = "",
    bool refresh = false,
  }) async {
    try {
      if (await checkInternet() == false) return;
      if (blogs.isNotEmpty && !refresh) return;

      setLoading(loadingFor);
      final response = await http.get(Uri.parse(Api.allBlogsEndpoint));

      final data = jsonDecode(response.body);

      debugPrint("👉 Response status: ${response.statusCode}");
      debugPrint("👉 Data: $data");

      if (response.statusCode == 200) {
        blogs.clear();
        List blogsData = data['blogs'] ?? [];
        blogs = blogsData
            .map<BlogModel>((blog) => BlogModel.fromJson(blog))
            .toList();

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

  /// ✅ Fetch Blog Details by ID
  Future<void> fetchBlogDetails({
    required String blogId,
    String loadingFor = "",
  }) async {
    try {
      if (await checkInternet() == false) return;

      debugPrint("Fetching blog details for ID: $blogId");

      setLoading(loadingFor);
      final response = await http.get(
        Uri.parse("${Api.blogDetailsEndpoint}$blogId"),
      );

      final data = jsonDecode(response.body);

      debugPrint("👉 Response status: ${response.statusCode}");
      debugPrint("👉 Data: $data");

      if (response.statusCode == 200) {
        final blogData =
            data['blog'] ?? data['blogDetails'] ?? data['data'] ?? {};
        blogDetails = BlogModel.fromJson(blogData);
        setLoading();
        notifyListeners();
      } else {
        toast(data['message'] ?? data['msg'] ?? 'Failed to fetch blog details');
        setLoading();
      }
    } catch (e) {
      setLoading();
      debugPrint("Error fetching blog details: $e");
    }
  }
}
