import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/Auth/login.dart';
import 'package:rent/Auth/profile_update_page.dart';
import 'package:rent/constants/api_endpoints.dart';
import 'package:rent/constants/checkInternet.dart' show checkInternet;
import 'package:rent/constants/goto.dart';
import 'package:rent/constants/toast.dart';
import 'package:rent/design/booking/my_booking_page.dart';
import 'package:rent/design/home_page.dart';
import 'package:rent/models/item_model.dart';
import 'package:rent/models/api_response.dart';

// import '../main.dart';

// Use the correct class name in the provider
final getAllItems = ChangeNotifierProvider<GetAllItems>((ref) => GetAllItems());

class GetAllItems with ChangeNotifier {
  List<ItemModel> allItems = [];
  List<ItemModel> orderedItems = [];
  //////
  String loadingFor = "";
  setLoading([String value = ""]) {
    loadingFor = value;
    notifyListeners();
  }

  fetchAllItems({required String loadingfor, String search = ""}) async {
    try {
      if (await checkInternet() == false) return;

      print("👉 loadingFor: $loadingfor");
      print("👉 search: $search");
      setLoading(loadingfor);
      final response = await http.get(
        Uri.parse("${Api.allItemsEndpoint}$search"),
        // body: {"search": search, "uid": uid},
      );

      final data = jsonDecode(response.body);

      print("👉Response status: ${response.statusCode}");
      print("👉 data: $data");
      if (response.statusCode == 200) {
        allItems.clear();
        final itemsData = data['items'] ?? [];
        allItems = itemsData
            .map<ItemModel>((item) => ItemModel.fromJson(item))
            .toList();

        setLoading("");
        notifyListeners();
      } else {
        toast(data['msg']);
      }
      setLoading("");
    } catch (e) {
      setLoading("");
      print("Error fetching my items: $e");
    }
  }

  // List orderedItems = [];

  /// ✅ Place Order
  Future<void> orderitems({
    required String userId,

    required String userCanPickupInDateRange,
    required String productId,
    required String product_by,
    required String totalprice_by,

    String loadingFor = "",
    required BuildContext context,
  }) async {
    if (await checkInternet() == false) return;

    setLoading(loadingFor);

    final response = await http.post(
      Uri.parse(Api.addOrderEndpoint),
      body: {
        "uid": userId,
        'userCanPickupInDateRange': userCanPickupInDateRange,
        'productId': productId.toString(),
        'product_by': product_by,
        'totalPriceByUser': totalprice_by,
      },
    );

    print("👉 Response status: ${response.statusCode}");
    print("👉 data: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      toast(data['msg'].toString());
      goto(const MyBookingPage());
    } else {
      toast(data['msg'] ?? "Failed to place order ❌");
    }
    setLoading();
  }
}
