import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/Auth/login.dart';
import 'package:rent/Auth/profile_update_page.dart';
import 'package:rent/constants/api_endpoints.dart';
import 'package:rent/constants/checkInternet.dart';
import 'package:rent/constants/goto.dart';
import 'package:rent/constants/toast.dart';
import 'package:rent/design/home_page.dart';
import 'package:rent/models/favorite_model.dart';

// import '../design/fav/fvrt.dart';
// import '../main.dart';

// Use the correct class name in the provider
final favrtdata = ChangeNotifierProvider<Favrt>((ref) => Favrt());

class Favrt with ChangeNotifier {
  List<FavoriteModel> favrt = [];
  //////
  String loadingFor = "";
  setLoading([String loadingName = ""]) {
    loadingFor = loadingName;
    notifyListeners();
  }

  favorItems({
    var uid,
    String loadingFor = "",
    var search = "",
    bool refresh = false,
  }) async {
    try {
      if (await checkInternet() == false) return;
      if (favrt.isNotEmpty && !refresh) return;

      setLoading(loadingFor);
      final response = await http.post(
        Uri.parse(Api.getFavEndpoint),
        body: {"uid": uid, "search": search},
      );

      final data = jsonDecode(response.body);

      debugPrint("👉Response status: ${response.statusCode}");
      log("👉 data: $data");
      if (response.statusCode == 200) {
        favrt.clear();
        final favItems = data['favItems'] ?? [];
        favrt = favItems
            .map<FavoriteModel>((item) => FavoriteModel.fromJson(item))
            .toList();
        debugPrint("👉 favrt: $favrt");
      } else {
        toast(data['msg']);
      }
      setLoading();
    } catch (e, st) {
      setLoading();
      debugPrint("💥 Error fetching my items: $e,st:$st");
      toast("Could not fetch data");
    } finally {
      setLoading();
    }
  }

  removefromfav({
    required String itemId,
    required String uid,
    String loadingFor = "",
  }) async {
    try {
      if (await checkInternet() == false) return;

      setLoading(loadingFor);
      final response = await http.delete(
        Uri.parse("${Api.unfavEndpoint}$itemId/$uid"),
      );

      final data = jsonDecode(response.body);

      debugPrint("👉Response status: ${response.statusCode}");
      debugPrint("👉 data: $data");
      if (response.statusCode == 200) {
        toast(data['msg']);
        favorItems(uid: uid);
      } else {
        toast(data['msg'], backgroundColor: Colors.red);
        setLoading();
      }
    } catch (e) {
      debugPrint("Error removing from favorites: $e");
    } finally {
      setLoading();
    }
  }

  addfavrt({
    required String uid,
    required itemId,
    String loadingFor = "",
  }) async {
    try {
      if (await checkInternet() == false) return;

      debugPrint("👉 loadingFor: $loadingFor");
      setLoading(loadingFor);
      final response = await http.post(
        Uri.parse(Api.addFavEndpoint),
        body: {"uid": uid, "itemid": itemId},
      );

      final data = jsonDecode(response.body);

      // print("👉Response status: ${response.statusCode}");
      // print("👉 data: $data");
      if (response.statusCode == 200) {
      } else {}
      toast(data['msg']);
      await favorItems(uid: uid);
      setLoading();
    } catch (e) {
      debugPrint("Error fetching my items: $e");
      setLoading();
    }
  }

  //////
  // showallaitems({required String uid}) async {
  //   try {
  //     if (await checkInternet() == false) return;

  //     print("Fetching my items for user ID: $uid");
  //     final response = await http.get(
  //       Uri.parse("https://thelocalrent.com/api/allitems$uid"),
  //     );

  //     final data = jsonDecode(response.body);

  //     print("👉Response status: ${response.statusCode}");
  //     print("👉 data: $data");
  //     if (response.statusCode == 200) {
  //       favrt = data['items'] ?? [];
  //       // listings =  [];

  //       notifyListeners();
  //     } else {
  //       toast(data['msg']);
  //     }
  //   } catch (e) {
  //     print("Error fetching my items: $e");
  //   }
  // }

  //
}
