import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/constants/checkInternet.dart';
import 'package:rent/constants/toast.dart';
import 'package:rent/models/blogmodel.dart';

// ✅ Provider for Blogs
final blogDataProvider = ChangeNotifierProvider<BlogData>((ref) => BlogData());

class BlogData with ChangeNotifier {
  List<Blogmodel> blogsData = [];

  // Loading state
  String loadingFor = "";

  void setLoading([String loadingName = ""]) {
    loadingFor = loadingName;
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

      setLoading(loadingFor);
      final response = await http.get(
        Uri.parse("https://thelocalrent.com/api/allblogs"),
      );

      final data = jsonDecode(response.body);

      print("👉 Response status: ${response.statusCode}");
      print("👉 Data: $data");

      if (response.statusCode == 200) {
        blogsData.clear();
        for (var item in data['blogs'] ?? []) {
          blogsData.add(Blogmodel.fromJson(item));
        }

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

  // not used
  /// ✅ Fetch Blog Details by ID
  // Future<void> fetchBlogDetails({
  //   required String blogId,
  //   String loadingFor = "",
  // }) async {
  //   try {
  //     if (await checkInternet() == false) return;

  //     print("Fetching blog details for ID: $blogId");

  //     setLoading(loadingFor);
  //     final response = await http.get(
  //       Uri.parse("https://thelocalrent.com/api/blogdetails/$blogId"),
  //     );

  //     final data = jsonDecode(response.body);

  //     print("👉 Response status: ${response.statusCode}");
  //     print("👉 Data: $data");

  //     if (response.statusCode == 200) {
  //       blogDetails = data['blog'] ?? data['blogDetails'] ?? data['data'] ?? {};
  //       print("👉 Blog details loaded");
  //       setLoading(false);
  //       notifyListeners();
  //     } else {
  //       toast(data['message'] ?? data['msg'] ?? 'Failed to fetch blog details');
  //       setLoading(false);
  //     }
  //   } catch (e) {
  //     setLoading(false);
  //     debugPrint("Error fetching blog details: $e");
  //   }
  // }

  ///////
}
