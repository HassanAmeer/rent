import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/Auth/login.dart';
import 'package:rent/Auth/profile_update_page.dart';
import 'package:rent/Auth/profile_details_page.dart';
import 'package:rent/constants/api_endpoints.dart';
import 'package:rent/constants/checkInternet.dart' show checkInternet;
import 'package:rent/constants/goto.dart';
import 'package:rent/constants/toast.dart';
import 'package:rent/design/home_page.dart';
import 'package:rent/models/item_model.dart';

// import '../main.dart';

// Use the correct class name in the provider
final listingDataProvider = ChangeNotifierProvider<ListingData>(
  (ref) => ListingData(),
);

class ListingData with ChangeNotifier {
  //////
  String loadingfor = "";
  setLoading([String value = ""]) {
    loadingfor = value;
    notifyListeners();
  }

  List<ItemModel> listings = [];
  fetchMyItems({
    required String uid,
    var loadingfor = "",
    var search = "",
    bool isRefresh = false,
  }) async {
    try {
      if (listings.isNotEmpty && isRefresh == false) return;
      if (await checkInternet() == false) return;

      setLoading(loadingfor);
      print("Fetching my items for user ID: $uid");
      final response = await http.post(
        Uri.parse(Api.myItemsEndpoint),
        body: {'search': search, "uid": uid},
      );
      final data = jsonDecode(response.body);

      debugPrint("👉Response status: ${response.statusCode}");
      debugPrint("👉 data: $data");
      if (response.statusCode == 200) {
        final itemsData = data['items'] ?? [];
        listings = itemsData
            .map<ItemModel>((item) => ItemModel.fromJson(item))
            .toList();
        // listings =  [];
        // debugPrint("👉 listings: $listings");

        setLoading("");
        notifyListeners();
      } else {
        toast(data['msg']);
        setLoading("");
      }
    } catch (e, st) {
      setLoading("");
      debugPrint("💥Error fetching my items: $e, st:$st");
    }
  }

  Future editsmyitems({
    required String itemId,
    required String uid,
    required Map newItemData,
    String loadingFor = "",
  }) async {
    try {
      if (await checkInternet() == false) return;
      setLoading(loadingFor);
      log('👉🏻 edit ItemData: $newItemData');

      var url = "${Api.myItemsEndpoint}/$itemId";
      log('👉🏻 edit ItemData url: $url');

      var req = http.MultipartRequest("PUT", Uri.parse(url));

      req.headers['Content-Type'] = 'application/json';

      req.fields['uid'] = uid;
      req.fields['title'] = newItemData['title'];
      req.fields['descriptioneditor'] = newItemData['description'];
      req.fields['avalibilityDays'] = newItemData['avalibilityDays'];
      req.fields['dailyrate'] = newItemData['dailyrate'];
      req.fields['weeklyrate'] = newItemData['weeklyrate'];
      req.fields['monthlyrate'] = newItemData['monthlyrate'];
      req.fields['catg_id'] = newItemData['category'].toString();
      req.fields['existingImages'] = jsonEncode(
        newItemData['existingImages'],
      ); // list of string example like : ['images/image1.png','images/image2.jpeg'];

      // for (var image in newItemData['newImages']) {
      //   if (await image.exists()) {
      //     req.files.add(
      //       await http.MultipartFile.fromPath('images[]', image.path),
      //     );
      //   }
      // }

      var sendedRequest = await req.send();
      var response = await sendedRequest.stream.bytesToString();

      if (sendedRequest.statusCode == 200 || sendedRequest.statusCode == 201) {
        toast("Successfully Updated", backgroundColor: Colors.green);
        fetchMyItems(uid: uid, loadingfor: "refresh");
      } else {
        toast("Failed to update", backgroundColor: Colors.red);
      }
      setLoading("");
    } catch (e, st) {
      setLoading("");
      debugPrint("💥Error editing my items: $e, st:$st");
      toast("error:$e");
    }
  }

  Future deleteItemById({
    required String itemId,
    required String uid,
    var loadingfor = "",
  }) async {
    if (await checkInternet() == false) return;

    setLoading(loadingfor);
    // debugPrint("uid : $uid");
    debugPrint("itemId : $itemId");

    final respnse = await http.delete(
      Uri.parse("${Api.deleteItemEndpoint}$itemId"),
    );
    setLoading("");

    // debugPrint("Response status: ${respnse.statusCode}");
    final data = jsonDecode(respnse.body);
    if ((respnse.statusCode == 200 || respnse.statusCode == 201)) {
      toast(data['msg'], backgroundColor: Colors.green);
      fetchMyItems(uid: uid, loadingfor: "refresh");
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
    required int catgId,
    required String dailyRate,
    required String weeklyRate,
    required String monthlyRate,
    required String availabilityDays,
    required String description,
    List images = const [],
    String loadingFor = "",
  }) async {
    try {
      if (await checkInternet() == false) return;

      setLoading(loadingFor);
      var req = http.MultipartRequest("POST", Uri.parse(Api.addItemEndpoint));

      req.headers['Content-Type'] = 'application/json';

      debugPrint("dailyRate:$dailyRate");

      //// for fields
      req.fields['uid'] = uid;
      req.fields['title'] = title;
      req.fields['catg_id'] = catgId.toString();
      req.fields['weekly_rate'] = weeklyRate;
      req.fields['availabilityrange'] =
          availabilityDays; // This field seems to be correctly assigned
      req.fields['descriptioneditor'] = description.replaceAll(
        '"',
        '',
      ); // Remove all double quotes
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

      debugPrint("👉🏻 sendedRequest status: ${sendedRequest.statusCode}");
      debugPrint("👉🏻 response data: $response");

      if (sendedRequest.statusCode == 200 || sendedRequest.statusCode == 201) {
        toast("Successfully Added", backgroundColor: Colors.green);
        fetchMyItems(uid: uid, loadingfor: "refresh");
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
