import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/constants/api_endpoints.dart';
import 'package:rent/constants/checkInternet.dart';
import 'package:rent/services/toast.dart';
import 'package:rent/models/rent_in_model.dart';

// Provider for rentals
final rentInProvider = ChangeNotifierProvider<RentInProvider>(
  (ref) => RentInProvider(),
);

class RentInProvider with ChangeNotifier {
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
      // debugPrint("Fetching fetchRentIn for user ID: $userId");

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

        debugPrint("👉 fetched RentIn loaded: ${rentInListData.length} items");
        setLoading();
        notifyListeners();
      } else {
        toast(data['msg'] ?? 'Failed to fetch rent in');
        setLoading();
      }
    } catch (e) {
      setLoading();
      debugPrint(" 💥 Error fetch RentIn: $e");
      toast("Error fetch RentIn: ${e.toString()}");
    } finally {
      setLoading();
    }
  }

  // Method to update rental status (delivered/not delivered)
  Future<void> updateRentnPickupTime({
    required String uid,
    required String orderId,
    required String pickup_date_range,
    required String total_price,
    String loadingFor = "",
  }) async {
    try {
      if (await checkInternet() == false) return;
      setLoading(loadingFor);

      final response = await http.post(
        Uri.parse(Api.updateRentInOrderEndpoint),
        body: {
          'uid': uid,
          'order_id': orderId,
          'pickup_date_range': pickup_date_range,
          'total_price': total_price,
        },
      );

      final data = jsonDecode(response.body);

      // debugPrint("👉Response status: ${response.statusCode}");
      debugPrint("👉 data: $data");

      if (response.statusCode == 200) {
        toast(data['msg'] ?? 'updated!');

        rentInListData
                .where((element) => element.id == int.parse(orderId))
                .first
                .userCanPickupInDateRange =
            pickup_date_range;
        rentInListData
                .where((element) => element.id == int.parse(orderId))
                .first
                .totalPriceByUser =
            int.tryParse(total_price.toString()) ?? 0;

        // Refresh rental details
        // await fetchRentInDetails(rentalId: rentalId);
        setLoading();
      } else {
        toast(data['msg'] ?? 'Failed to update status');
        setLoading();
      }
    } catch (e) {
      setLoading();
      debugPrint("updateRentalStatus Error: $e");
      toast("Try Later: ${e.toString()}");
    } finally {
      setLoading();
    }
  }

  Future<void> deleteOrder({
    required String orderId,
    String loadingFor = "",
  }) async {
    try {
      if (await checkInternet() == false) return;
      setLoading(loadingFor);

      final response = await http.delete(
        Uri.parse(Api.deleteRentInOrderEndpoint + orderId),
      );

      final data = jsonDecode(response.body);

      // debugPrint("👉Response status: ${response.statusCode}");
      debugPrint("👉 data: $data");

      if (response.statusCode == 200) {
        toast(data['msg'] ?? 'Order Deleted!');
        rentInListData.removeWhere((e) => e.id == int.parse(orderId));
        // Refresh rental details
        // await fetchRentInDetails(rentalId: rentalId);
        setLoading();
      } else {
        toast(data['msg'] ?? 'Failed to Delete Order!');
        setLoading();
      }
    } catch (e) {
      setLoading();
      debugPrint("deleteOrder Error: $e");
      toast("Try Later: ${e.toString()}");
    } finally {
      setLoading();
    }
  }

  // Future<void> updateRentalStatus({
  //   required String rentalId,
  //   required String status, // "1" for delivered, "0" for not delivered
  //   String loadingFor = "",
  // }) async {
  //   try {
  //     if (await checkInternet() == false) return;

  //     debugPrint("Updating rental status for ID: $rentalId to $status");

  //     setLoading(loadingFor);
  //     final response = await http.post(
  //       Uri.parse(Api.updateRentalStatusEndpoint),
  //       body: {'rentalId': rentalId, 'delivered': status},
  //     );

  //     final data = jsonDecode(response.body);

  //     debugPrint("👉Response status: ${response.statusCode}");
  //     debugPrint("👉 data: $data");

  //     if (response.statusCode == 200) {
  //       toast(data['msg'] ?? 'Status updated successfully');
  //       // Refresh rental details
  //       await fetchRentInDetails(rentalId: rentalId);
  //       setLoading();
  //     } else {
  //       toast(data['msg'] ?? 'Failed to update status');
  //       setLoading();
  //     }
  //   } catch (e) {
  //     setLoading();
  //     debugPrint("Error updating rental status: $e");
  //     toast("Error updating status: ${e.toString()}");
  //   }
  // }
}
