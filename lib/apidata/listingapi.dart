import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/Auth/login.dart';
import 'package:rent/Auth/profile_update_page.dart';
import 'package:rent/Auth/profile_details_page.dart';
import 'package:rent/constants/goto.dart';
import 'package:rent/constants/toast.dart';
import 'package:rent/design/home_page.dart';

// import '../main.dart';

// Use the correct class name in the provider
final listingDataProvider = ChangeNotifierProvider<ListingData>(
  (ref) => ListingData(),
);

class ListingData with ChangeNotifier {
  var listings = [];

  //////
  String loadingfor = "";
  setLoading([String value = ""]) {
    loadingfor = value;

    notifyListeners();
  }

  fetchMyItems({
    required String uid,
    var loadingfor = "",
    var search = "",
  }) async {
    try {
      setLoading(loadingfor);
      print("Fetching my items for user ID: $uid");
      final response = await http.post(
        Uri.parse("https://thelocalrent.com/api/myitems"),
        body: {'search': search, "uid": uid},
      );
      final data = jsonDecode(response.body);

      print("👉Response status: ${response.statusCode}");
      print("👉 data: $data");
      if (response.statusCode == 200) {
        listings = data['items'] ?? [];
        // listings =  [];
        setLoading("");
        notifyListeners();
      } else {
        toast(data['msg']);
        setLoading("");
      }
    } catch (e) {
      setLoading("");
      print("Error fetching my items: $e");
    }
  }

  editsmyitems({
    required String itemId,
    required String uid,
    Map? newItemData,
  }) async {
    try {
      final response = await http.put(
        Uri.parse("https://thelocalrent.com/api/myitems/$itemId"),
        body: newItemData,
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        fetchMyItems(uid: uid);
        toast(data["msg"], backgroundColor: Colors.green);
      } else {
        toast(data["msg"], backgroundColor: Colors.red);
      }
    } catch (e) {
      print("errore$e");
    }
  }

  Future deleteNotifications({
    required String notificationId,
    required String uid,
    var loadingfor = "",
  }) async {
    // print("$loadingfor");
    setLoading(loadingfor);
    debugPrint("notificationId : $notificationId");
    // debugPrint("uid : $uid");

    final respnse = await http.delete(
      Uri.parse("https://thelocalrent.com/api/delitem/$notificationId"),
    );
    setLoading("");
    // debugPrint("Response status: ${respnse.statusCode}");
    final data = jsonDecode(respnse.body);
    if ((respnse.statusCode == 200 || respnse.statusCode == 201)) {
      toast(data['msg'], backgroundColor: Colors.green);
      fetchMyItems(uid: uid);
    } else {
      toast(data['msg'], backgroundColor: Colors.red);
    }
    setLoading("");
  }

  //
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
    List images = const [],
    String loadingFor = "",
  }) async {
    try {
      setLoading(loadingFor);
      var req = http.MultipartRequest(
        "POST",
        Uri.parse("https://thelocalrent.com/api/additem"),
      );

      req.headers['Content-Type'] = 'application/json';

      print("dailyRate:" + dailyRate);

      //// for fields
      req.fields['uid'] = uid;
      req.fields['title'] = title;
      req.fields['catgname'] = catgname.toString();
      req.fields['weekly_rate'] = weeklyRate;
      req.fields['availabilityrange'] = availabilityDays;
      req.fields['description'] = description;
      req.fields['monthly_rate'] = monthlyRate;
      req.fields['daily_rate'] = dailyRate;

      if (images.isNotEmpty) {
        for (var i = 0; i < images.length; i++) {
          if (await File(images[i].path!).exists()) {
            req.files.add(
              await http.MultipartFile.fromPath('images[$i]', images[i].path!),
            );
          }
        }
      }

      var sendedRequest = await req.send();
      var response = await sendedRequest.stream.bytesToString();

      debugPrint("😊 sendedRequest status: ${sendedRequest.statusCode}");
      debugPrint("😊 response data: ${response}");

      if (sendedRequest.statusCode == 200 || sendedRequest.statusCode == 201) {
        toast("Successfully Added", backgroundColor: Colors.green);
        fetchMyItems(uid: uid, loadingfor: "123");
      } else {
        toast("Failed to upload", backgroundColor: Colors.red);
      }

      setLoading();
    } catch (e) {
      debugPrint("Error adding listing: $e");
      toast("Network error: Please check your connection");
    } finally {
      setLoading();
    }
  }

  //
}
