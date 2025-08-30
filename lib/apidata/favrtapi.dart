import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/Auth/login.dart';
import 'package:rent/Auth/profile_update_page.dart';
import 'package:rent/constants/checkInternet.dart';
import 'package:rent/constants/goto.dart';
import 'package:rent/constants/toast.dart';
import 'package:rent/design/home_page.dart';

// Provider
final favrtdata = ChangeNotifierProvider<Favrt>((ref) => Favrt());

class Favrt with ChangeNotifier {
  var favrt = [];
  String loadingFor = "";

  setLoading([String loadingName = ""]) {
    loadingFor = loadingName;
    notifyListeners();
  }

  /// 🔥 Fetch favorite items
  favoritems({var uid, String loadingFor = "", var search = ""}) async {
    try {
      if (await checkInternet() == false) return;

      print("🔍 Fetching favorite items for UID: $uid");
      setLoading(loadingFor);

      final response = await http.post(
        Uri.parse("https://thelocalrent.com/api/getfav"),
        body: {"uid": uid, "search": search},
      );

      print("👉 API URL: ${response.request?.url}");
      print("👉 Response Status: ${response.statusCode}");
      print("👉 Raw Response: ${response.body}");

      final data = jsonDecode(response.body);
      print("👉 Parsed Data: $data");

      if (response.statusCode == 200) {
        favrt.clear();
        favrt = data['favItems'] ?? [];
        print("✅ Total Favorites: ${favrt.length}");
      } else {
        toast(data['msg']);
      }
      setLoading();
    } catch (e) {
      setLoading();
      print("❌ Error fetching favorite items: $e");
    }
  }

  /// 🔥 Remove from favorites
  removefromfav({
    required String itemId,
    required String uid,
    String loadingFor = "",
  }) async {
    try {
      if (await checkInternet() == false) return;

      print("🗑 Removing item $itemId from favorites for UID: $uid");
      setLoading(loadingFor);

      final response = await http.delete(
        Uri.parse("https://thelocalrent.com/api/unfav/$itemId/$uid"),
      );

      print("👉 API URL: ${response.request?.url}");
      print("👉 Response Status: ${response.statusCode}");
      print("👉 Raw Response: ${response.body}");

      final data = jsonDecode(response.body);
      print("👉 Parsed Data: $data");

      if (response.statusCode == 200) {
        toast(data['msg']);
        favoritems(uid: uid);
      } else {
        toast(data['msg'], backgroundColor: Colors.red);
        setLoading();
      }
    } catch (e) {
      print("❌ Error removing from favorites: $e");
    }
  }

  /// 🔥 Add to favorites
  addfavrt({
    required String uid,
    required itemId,
    String loadingFor = "",
  }) async {
    try {
      if (await checkInternet() == false) return;

      print("➕ Adding item $itemId to favorites for UID: $uid");
      setLoading(loadingFor);

      final response = await http.post(
        Uri.parse("https://thelocalrent.com/api/addfav/"),
        body: {"uid": uid, "itemid": itemId},
      );

      print("👉 API URL: ${response.request?.url}");
      print("👉 Response Status: ${response.statusCode}");
      print("👉 Raw Response: ${response.body}");

      final data = jsonDecode(response.body);
      print("👉 Parsed Data: $data");

      toast(data['msg']);
      await favoritems(uid: uid);
      setLoading();
    } catch (e) {
      debugPrint("❌ Error adding to favorites: $e");
      setLoading();
    }
  }

  /// 🔥 Show all items
  showallaitems({required String uid}) async {
    try {
      if (await checkInternet() == false) return;

      print("🔍 Fetching all items for UID: $uid");
      final response = await http.get(
        Uri.parse("https://thelocalrent.com/api/allitems$uid"),
      );

      print("👉 API URL: ${response.request?.url}");
      print("👉 Response Status: ${response.statusCode}");
      print("👉 Raw Response: ${response.body}");

      final data = jsonDecode(response.body);
      print("👉 Parsed Data: $data");

      if (response.statusCode == 200) {
        favrt = data['items'] ?? [];
        print("✅ Total All Items: ${favrt.length}");
        notifyListeners();
      } else {
        toast(data['msg']);
      }
    } catch (e) {
      print("❌ Error fetching all items: $e");
    }
  }
}
