import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/constants/api_endpoints.dart';
import 'package:rent/constants/checkInternet.dart';
import 'package:rent/services/goto.dart';
import 'package:rent/services/toast.dart';
import 'package:rent/design/home_page.dart';
import 'package:rent/models/favorite_model.dart';
import 'package:rent/services/cache_service.dart';

// import '../design/fav/fvrt.dart';
// import '../main.dart';

// Use the correct class name in the provider
final favProvider = ChangeNotifierProvider<Favrt>((ref) => Favrt());

class Favrt with ChangeNotifier {
  List<FavoriteModel> favouriteItems = [];
  //////
  String loadingFor = "";
  setLoading([String loadingName = ""]) {
    loadingFor = loadingName;
    notifyListeners();
  }

  getAllFavItems({
    var uid,
    String loadingFor = "",
    var search = "",
    bool refresh = false,
  }) async {
    try {
      String cacheKey = '';
      dynamic cachedData;

      if (search == null || search.toString().isEmpty) {
        cacheKey = CacheService.generateKey('fav_items', {'uid': uid});
        // ✅ Load from cache first ONLY if no search
        cachedData = CacheService.getCache(cacheKey);

        if (cachedData != null &&
            cachedData is Map &&
            cachedData['favItems'] is List) {
          favouriteItems = (cachedData['favItems'] as List)
              .map<FavoriteModel>((item) => FavoriteModel.fromJson(item))
              .toList()
              .reversed
              .toList();
          notifyListeners();
          debugPrint(
            '📦 Fav items loaded from cache: ${favouriteItems.length} items',
          );

          if (!refresh &&
              !CacheService.isCacheStale(cacheKey, maxAgeMinutes: 10)) {
            return;
          }
        } else {
          setLoading(loadingFor);
        }
      } else {
        setLoading(loadingFor);
      }

      if (await checkInternet() == false) {
        if (cachedData == null) setLoading();
        return;
      }

      final response = await http.post(
        Uri.parse(Api.getFavEndpoint),
        body: {"uid": uid, "search": search},
      );

      final data = jsonDecode(response.body);
      // log("👉 data: $data");

      if (response.statusCode == 200) {
        if ((search == null || search.toString().isEmpty)) {
          await CacheService.saveCache(cacheKey, data);
        }

        favouriteItems.clear();
        List favItems = data['favItems'] ?? [];
        favouriteItems = favItems
            .map<FavoriteModel>((item) => FavoriteModel.fromJson(item))
            .toList()
            .reversed
            .toList();
        // debugPrint("👉 favouriteItems: $favouriteItems");
        setLoading();
        notifyListeners();
      } else {
        toast(data['msg']);
        setLoading();
      }
    } catch (e, st) {
      setLoading();
      debugPrint("💥 Error fetching my items: $e,st:$st");
      toast("Could not fetch data");
    } finally {
      setLoading();
    }
  }

  togglefavrt({
    required String uid,
    required itemId,
    String loadingFor = "",
  }) async {
    try {
      if (await checkInternet() == false) return;
      setLoading(loadingFor);

      final response = await http.post(
        Uri.parse(Api.togglefavEndpoint),
        body: {"uid": uid, "itemid": itemId},
      );

      final data = jsonDecode(response.body);

      // print("👉 data: $data");
      // if (response.statusCode == 200) {
      // } else {}

      if (favouriteItems.any((e) => e.id == itemId)) {
        favouriteItems.removeWhere((e) => e.id == itemId);
      } else {
        // favouriteItems.add(FavoriteModel(id: itemId));
      }

      toast(data['msg']);
      setLoading();
      await getAllFavItems(uid: uid, loadingFor: 'refresh', refresh: true);
    } catch (e) {
      debugPrint("Error fetching my items: $e");
      setLoading();
    }
  }
}
