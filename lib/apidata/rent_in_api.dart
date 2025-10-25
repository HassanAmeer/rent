import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/constants/api_endpoints.dart';
import 'package:rent/constants/checkInternet.dart';
import 'package:rent/constants/toast.dart';
import 'package:rent/models/rent_in_model.dart';

// Provider for rentals
final rentalDataProvider = ChangeNotifierProvider<RentalData>(
  (ref) => RentalData(),
);

class RentalData with ChangeNotifier {
  Map<String, dynamic> rentalDetails = {};

  // Loading state management
  String loadingFor = "";
  void setLoading([String loadingName = ""]) {
    loadingFor = loadingName;
    notifyListeners();
  }

  List<RentInModel> rentInListData = [];
  Future<void> fetchRentIn({
    required String userId,
    String loadingFor = "",
    required String search,
    bool refresh = false,
  }) async {
    try {
      if (await checkInternet() == false) return;
      if (rentInListData.isNotEmpty && !refresh) return;
      debugPrint("Fetching my rentals for user ID: $userId");

      setLoading(loadingFor);
      final response = await http.post(
        Uri.parse(Api.rentInEndpoint),
        body: {'search': search, "uid": userId},
      );

      final data = jsonDecode(response.body);

      // debugPrint("👉Response status: ${response.statusCode}");
      debugPrint("👉 data: $data");

      if (response.statusCode == 200) {
        rentInListData.clear();
        List rentalsData = data['rentals'] ?? [];
        rentInListData = rentalsData
            .map<RentInModel>((e) => RentInModel.fromJson(e))
            .toList()
            .reversed
            .toList();

        debugPrint("👉 Rentals loaded: ${rentInListData.length} items");
        setLoading();
        notifyListeners();
      } else {
        toast(data['msg'] ?? 'Failed to fetch rentals');
        setLoading();
      }
    } catch (e) {
      setLoading();
      debugPrint(" 💥 Error fetching rental items: $e");
      toast("Error Fetching Rentals: ${e.toString()}");
    } finally {
      setLoading();
    }
  }

  Future<void> fetchRentInDetails({
    required String rentalId,
    String loadingFor = "",
  }) async {
    try {
      if (await checkInternet() == false) return;
      setLoading(loadingFor);
      final response = await http.get(
        Uri.parse("${Api.rentalDetailsEndpoint}$rentalId"),
      );

      final data = jsonDecode(response.body);

      debugPrint("👉Response status: ${response.statusCode}");
      debugPrint("👉 data: $data");

      if (response.statusCode == 200) {
        rentalDetails =
            data['rental'] ?? data['rentalDetails'] ?? data['data'] ?? {};
        debugPrint("👉 Rental details loaded");
        setLoading();
        notifyListeners();
      } else {
        toast(
          data['message'] ?? data['msg'] ?? 'Failed to fetch rental details',
        );
        setLoading();
      }
    } catch (e) {
      setLoading();
      debugPrint("Error fetching rental details: $e");
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

      debugPrint("Updating rental status for ID: $rentalId to $status");

      setLoading(loadingFor);
      final response = await http.post(
        Uri.parse(Api.updateRentalStatusEndpoint),
        body: {'rentalId': rentalId, 'delivered': status},
      );

      final data = jsonDecode(response.body);

      debugPrint("👉Response status: ${response.statusCode}");
      debugPrint("👉 data: $data");

      if (response.statusCode == 200) {
        toast(data['message'] ?? data['msg'] ?? 'Status updated successfully');
        // Refresh rental details
        await fetchRentInDetails(rentalId: rentalId);
        setLoading();
      } else {
        toast(data['message'] ?? data['msg'] ?? 'Failed to update status');
        setLoading();
      }
    } catch (e) {
      setLoading();
      debugPrint("Error updating rental status: $e");
      toast("Error updating status: ${e.toString()}");
    }
  }
}
