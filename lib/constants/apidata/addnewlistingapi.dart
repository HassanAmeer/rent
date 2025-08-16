import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/constants/toast.dart';

// ✅ Provider for Listings
final listingDataProvider = ChangeNotifierProvider<ListingData>(
  (ref) => ListingData(),
);

class ListingData with ChangeNotifier {
  String loadingFor = "";
  bool isLoading = false;

  void setLoading(bool value, [String loadingName = ""]) {
    loadingFor = loadingName;
    isLoading = value;
    notifyListeners();
  }

  /// ✅ Add New Listing
  Future<void> addNewListing({
    required String uid,
    required String title,
    required String catgname,
    required String dailyRate,
    required String weeklyRate,
    required String monthlyRate,
    required String availabilityDays,
    required String description,
  }) async {
    try {
      print("Adding new listing...");
      print("👉 UID: $uid");
      print("👉 Title: $title");
      print("👉 Category: $catgname");

      // Validate required fields
      if (uid.isEmpty || title.isEmpty || catgname.isEmpty) {
        toast("Please fill all required fields");
        return;
      }

      setLoading(true, "addListing");

      // Prepare request body
      final requestBody = {
        'uid': uid,
        'title': title,
        'catgname': catgname,
        'daily_rate': dailyRate.isEmpty ? '0' : dailyRate,
        'weekly_rate': weeklyRate.isEmpty ? '0' : weeklyRate,
        'monthly_rate': monthlyRate.isEmpty ? '0' : monthlyRate,
        'availabilityDays': availabilityDays,
        'description': description,
      };

      print("👉 Request Body: $requestBody");

      // Use POST request with form data
      final response = await http.post(
        Uri.parse("https://thelocalrent.com/api/additem/"),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: requestBody,
      );

      print("👉 Response status: ${response.statusCode}");
      print("👉 Response body: ${response.body}");

      final data = jsonDecode(response.body);
      print("👉 Parsed Data: $data");

      if (response.statusCode == 200) {
        // Check multiple possible success indicators
        bool isSuccess =
            data['success'] == true ||
            data['status'] == 'success' ||
            data['success'] == 'true' ||
            data['msg']?.toString().toLowerCase().contains('success') == true ||
            data['message']?.toString().toLowerCase().contains('success') ==
                true;

        if (isSuccess) {
          toast(data['message'] ?? data['msg'] ?? "Listing added successfully");
        } else {
          toast(
            data['message'] ??
                data['msg'] ??
                data['error'] ??
                "Failed to add listing",
          );
        }
      } else {
        toast(
          data['message'] ??
              data['msg'] ??
              data['error'] ??
              "Server error occurred",
        );
      }

      setLoading(false);
    } catch (e) {
      setLoading(false);
      debugPrint("Error adding listing: $e");
      toast("Network error: Please check your connection");
    }
  }
}
