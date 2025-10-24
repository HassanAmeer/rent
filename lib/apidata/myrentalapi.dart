import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/constants/api_endpoints.dart';
import 'package:rent/constants/checkInternet.dart';
import 'package:rent/constants/toast.dart';

// Provider for rentals
final rentalDataProvider = ChangeNotifierProvider<RentalData>(
  (ref) => RentalData(),
);

class RentalData with ChangeNotifier {
  List<dynamic> rentals = [];
  Map<String, dynamic> rentalDetails = {};

  // Loading state management
  String loadingFor = "";
  bool isLoading = false;

  void setLoading(bool value, [String loadingName = ""]) {
    loadingFor = loadingName;
    isLoading = value;
    notifyListeners();
  }

  Future<void> fetchMyRentals({
    required String userId,
    String loadingFor = "",
    required String search,
  }) async {
    try {
      if (await checkInternet() == false) return;

      print("Fetching my rentals for user ID: $userId");

      setLoading(true, loadingFor);
      final response = await http.post(
        Uri.parse(Api.myRentalsEndpoint),
        body: {'search': search, "uid": userId},
      );

      final data = jsonDecode(response.body);

      print("👉Response status: ${response.statusCode}");
      print("👉 data: $data");

      if (response.statusCode == 200) {
        rentals.clear();
        // Try different possible field names for rental data
        rentals = data['rentals'] ?? [];
        print("👉 Rentals loaded: ${rentals.length} items");
        setLoading(false);
        notifyListeners();
      } else {
        toast(data['message'] ?? data['msg'] ?? 'Failed to fetch rentals');
        setLoading(false);
      }
    } catch (e) {
      setLoading(false);
      debugPrint("Error fetching rental items: $e");
      toast("Error fetching rentals: ${e.toString()}");
    }
  }

  Future<void> fetchRentalDetails({
    required String rentalId,
    String loadingFor = "",
  }) async {
    try {
      if (await checkInternet() == false) return;

      print("Fetching rental details for ID: $rentalId");

      setLoading(true, loadingFor);
      final response = await http.get(
        Uri.parse("${Api.rentalDetailsEndpoint}$rentalId"),
      );

      final data = jsonDecode(response.body);

      print("👉Response status: ${response.statusCode}");
      print("👉 data: $data");

      if (response.statusCode == 200) {
        rentalDetails =
            data['rental'] ?? data['rentalDetails'] ?? data['data'] ?? {};
        print("👉 Rental details loaded");
        setLoading(false);
        notifyListeners();
      } else {
        toast(
          data['message'] ?? data['msg'] ?? 'Failed to fetch rental details',
        );
        setLoading(false);
      }
    } catch (e) {
      setLoading(false);
      print("Error fetching rental details: $e");
      toast("Error fetching rental details: ${e.toString()}");
    }
  }

  // Method to update rental status (delivered/not delivered)
  Future<void> updateRentalStatus({
    required String rentalId,
    required String status, // "1" for delivered, "0" for not delivered
    String loadingFor = "",
  }) async {
    try {
      if (await checkInternet() == false) return;

      print("Updating rental status for ID: $rentalId to $status");

      setLoading(true, loadingFor);
      final response = await http.post(
        Uri.parse(Api.updateRentalStatusEndpoint),
        body: {'rentalId': rentalId, 'delivered': status},
      );

      final data = jsonDecode(response.body);

      print("👉Response status: ${response.statusCode}");
      print("👉 data: $data");

      if (response.statusCode == 200) {
        toast(data['message'] ?? data['msg'] ?? 'Status updated successfully');
        // Refresh rental details
        await fetchRentalDetails(rentalId: rentalId);
        setLoading(false);
      } else {
        toast(data['message'] ?? data['msg'] ?? 'Failed to update status');
        setLoading(false);
      }
    } catch (e) {
      setLoading(false);
      print("Error updating rental status: $e");
      toast("Error updating status: ${e.toString()}");
    }
  }
}
