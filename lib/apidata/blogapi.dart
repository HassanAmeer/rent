import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/constants/api_endpoints.dart';
import 'package:rent/constants/checkInternet.dart';
import 'package:rent/services/toast.dart';
import 'package:rent/models/blog_model.dart';
import 'package:rent/services/cache_service.dart';

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
      const cacheKey = 'all_blogs';

      // ✅ Load from cache first
      final cachedData = CacheService.getCache(cacheKey);
      if (cachedData != null &&
          cachedData is Map &&
          cachedData['blogs'] is List) {
        blogs = (cachedData['blogs'] as List)
            .map<BlogModel>((blog) => BlogModel.fromJson(blog))
            .toList();
        notifyListeners();
        debugPrint('📦 Blogs loaded from cache: ${blogs.length} items');

        if (!refresh &&
            !CacheService.isCacheStale(cacheKey, maxAgeMinutes: 30)) {
          return;
        }
      } else {
        setLoading(loadingFor);
      }

      if (await checkInternet() == false) {
        if (cachedData == null) setLoading();
        return;
      }

      final response = await http.get(Uri.parse(Api.allBlogsEndpoint));

      final data = jsonDecode(response.body);

      debugPrint("👉 Response status: ${response.statusCode}");
      debugPrint("👉 Data: $data");

      if (response.statusCode == 200) {
        await CacheService.saveCache(cacheKey, data);

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
      final cacheKey = CacheService.generateKey('blog_details', {'id': blogId});

      // ✅ Load from cache first
      final cachedData = CacheService.getCache(cacheKey);
      if (cachedData != null && cachedData is Map) {
        final blogData =
            cachedData['blog'] ??
            cachedData['blogDetails'] ??
            cachedData['data'] ??
            {};
        if (blogData is Map && blogData.isNotEmpty) {
          blogDetails = BlogModel.fromJson(Map<String, dynamic>.from(blogData));
          notifyListeners();
          debugPrint('📦 Blog details loaded from cache');

          if (!CacheService.isCacheStale(cacheKey, maxAgeMinutes: 60)) {
            return;
          }
        }
      } else {
        setLoading(loadingFor);
      }

      if (await checkInternet() == false) {
        if (cachedData == null) setLoading();
        return;
      }

      debugPrint("Fetching blog details for ID: $blogId");

      final response = await http.get(
        Uri.parse("${Api.blogDetailsEndpoint}$blogId"),
      );

      final data = jsonDecode(response.body);

      debugPrint("👉 Response status: ${response.statusCode}");
      debugPrint("👉 Data: $data");

      if (response.statusCode == 200) {
        await CacheService.saveCache(cacheKey, data);

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
