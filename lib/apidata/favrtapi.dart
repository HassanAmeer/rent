import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/Auth/login.dart';
import 'package:rent/Auth/profile_update_page.dart';
import 'package:rent/constants/goto.dart';
import 'package:rent/constants/toast.dart';
import 'package:rent/design/home_page.dart';

// import '../design/fav/fvrt.dart';
// import '../main.dart';

// Use the correct class name in the provider
final favrtdata = ChangeNotifierProvider<Favrt>((ref) => Favrt());

class Favrt with ChangeNotifier {
  var favrt = [];
  //////
  String loadingFor = "";
  bool isLoading = false;
  setLoading(bool value, [String loadingName = ""]) {
    loadingFor = loadingName;
    isLoading = value;
    notifyListeners();
  }

  favoritems({required String uid, String loadingFor = ""}) async {
    try {
      print("Fetching my items for user ID: $uid");

      setLoading(true, loadingFor);
      final response = await http.get(
        Uri.parse("https://thelocalrent.com/api/getfav/$uid"),
      );

      final data = jsonDecode(response.body);

      print("👉Response status: ${response.statusCode}");
      print("👉 data: $data");
      if (response.statusCode == 200) {
        favrt.clear();
        favrt = data['favItems'] ?? [];
        // listings =  []
        setLoading(false);
      } else {
        toast(data['msg']);
      }
    } catch (e) {
      setLoading(false);
      print("Error fetching my items: $e");
    }
  }

  removefromfav({
    required String itemId,
    required String uid,
    String loadingFor = "",
  }) async {
    try {
      setLoading(true, loadingFor);
      final response = await http.delete(
        Uri.parse("https://thelocalrent.com/api/unfav/$itemId/$uid"),
      );

      final data = jsonDecode(response.body);

      print("👉Response status: ${response.statusCode}");
      print("👉 data: $data");
      if (response.statusCode == 200) {
        toast(data['msg']);
        favoritems(uid: uid);
      } else {
        toast(data['msg'], backgroundColor: Colors.red);
      }
    } catch (e) {
      print("Error removing from favorites: $e");
    }
  }

  addfav({
    required String itemId,
    required String uid,
    String loadingFor = "",
  }) async {
    setLoading(true, loadingFor);
    try {
      final response = await http.delete(
        Uri.parse("https://thelocalrent.com/api/unfav/$itemId/$uid"),
      );

      final data = jsonDecode(response.body);

      print("👉Response status: ${response.statusCode}");
      print("👉 data: $data");
      if (response.statusCode == 200) {
        toast(data['msg']);
        favoritems(uid: uid);
      } else {
        toast(data['msg'], backgroundColor: Colors.red);
      }
      setLoading(false);
    } catch (e) {
      setLoading(false);
      print("Error removing from favorites: $e");
    }
  }

  addfavrt({
    required String uid,
    required itemId,
    String loadingFor = "",
  }) async {
    try {
      print("👉 loadingFor: $loadingFor");
      setLoading(true, loadingFor);
      // print("Fetching my items for user ID: $uid");
      final response = await http.post(
        Uri.parse("https://thelocalrent.com/api/addfav/"),
        body: {"uid": uid, "itemid": itemId},
      );

      final data = jsonDecode(response.body);

      // print("👉Response status: ${response.statusCode}");
      // print("👉 data: $data");
      if (response.statusCode == 200) {
      } else {}
      //
      toast(data['msg']);
      await favoritems(uid: uid);
      setLoading(false);
    } catch (e) {
      debugPrint("Error fetching my items: $e");
      setLoading(false);
    }
  }

  //////
  showallaitems({required String uid}) async {
    try {
      print("Fetching my items for user ID: $uid");
      final response = await http.get(
        Uri.parse("https://thelocalrent.com/api/allitems$uid"),
      );

      final data = jsonDecode(response.body);

      print("👉Response status: ${response.statusCode}");
      print("👉 data: $data");
      if (response.statusCode == 200) {
        favrt = data['items'] ?? [];
        // listings =  [];

        notifyListeners();
      } else {
        toast(data['msg']);
      }
    } catch (e) {
      print("Error fetching my items: $e");
    }
  }

  //
}
