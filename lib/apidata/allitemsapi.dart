import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/constants/api_endpoints.dart';
import 'package:rent/constants/checkInternet.dart' show checkInternet;
import 'package:rent/services/goto.dart';
import 'package:rent/services/toast.dart';
import 'package:rent/design/rentout/rent_out_page.dart';
import 'package:rent/design/home_page.dart';
import 'package:rent/models/item_model.dart';
import 'package:rent/models/api_response.dart';

import '../design/rentin/rent_in_page.dart';
import '../models/favorite_model.dart';

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

  fetchAllItems({
    required String loadingfor,
    String search = "",
    bool refresh = false,
  }) async {
    try {
      if (await checkInternet() == false) return;
      if (allItems.isNotEmpty && !refresh) return;

      setLoading(loadingfor);
      debugPrint("👉 search: $search");

      final response = await http.get(
        Uri.parse("${Api.allItemsEndpoint}$search"),
        // body: {"search": search, "uid": uid},
      );

      final data = jsonDecode(response.body);

      debugPrint("👉Response status: ${response.statusCode}");
      debugPrint("👉 data: $data");
      if (response.statusCode == 200) {
        allItems.clear();
        List itemsData = data['items'] ?? [];
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
      debugPrint("Error fetching my items: $e");
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

    // print("userId:$userId");
    // return;
    setLoading(loadingFor);

    final response = await http.post(
      Uri.parse(Api.addOrderEndpoint),
      body: {
        "uid": userId,
        'userCanPickupInDateRange': userCanPickupInDateRange,
        'productId': productId.toString(),
        'product_by': product_by, // user id who listed a product
        'totalPriceByUser': totalprice_by,
      },
    );

    debugPrint("👉 Response status: ${response.statusCode}");
    debugPrint("👉 data: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      toast(data['msg'].toString());
      goto(const RentInPage(refresh: true));
    } else {
      toast(data['msg'] ?? "Failed to place order ❌");
    }
    setLoading();
  }
}
