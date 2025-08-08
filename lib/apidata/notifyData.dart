import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/Auth/login.dart';
import 'package:rent/Auth/profile_update_page.dart';
import 'package:rent/auth/profile_details_page.dart';
import 'package:rent/constants/goto.dart';
import 'package:rent/constants/toast.dart';
import 'package:rent/home_page.dart';

import '../main.dart';

final notifyData = ChangeNotifierProvider<NotifyData>((ref) => NotifyData());

class NotifyData with ChangeNotifier {
  //////
  bool isLoading = false;
  setLoading(bool value) {
    notifyListeners();
    isLoading = value;
    notifyListeners();
  }

  List notify = [];
  Future getNotifyData({required String uid}) async {
    try {
      setLoading(true);
      final response = await http.get(
        Uri.parse("https://thelocalrent.com/api/notifications/$uid"),
      );
      debugPrint("👉 getNotifyData Response status: ${response.statusCode}");
      // log(" 👉 getNotifyData Response body: ${response.body}");
      var result = json.decode(response.body);
      // print("👉 Response: $result");

      setLoading(false);
      if (response.statusCode == 200 || response.statusCode == 201) {
        toast(result['msg']);
        notify = result['notifications'];
        setLoading(false);
      } else {
        toast(result['msg'], backgroundColor: Colors.red);
      }
      setLoading(false);
    } catch (e) {
      setLoading(false);
    }
  }
}




// {
//    "success":true,
//    "msg":"Notifications Fetched",
//    "notifications":[
//       {
//          "id":51,
//          "from":1,
//          "to":1,
//          "title":"New Booking for Kayake",
//          "desc":"<div style=\"display: flex; padding: 15px; background: white; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); border-radius: 8px; margin-bottom: 10px; align-items: center;\" class=\"shimmer\"><div style=\"flex: 1; display: flex; align-items: center;\"><img src=\"https:\/\/thelocalrent.com\/uploads\/images\/12.png\" alt=\"Product Image\" style=\"width: 100px; height: 100px; border-radius: 8px; margin-right: 15px;\"\/><div><h3 style=\"margin: 0;\">Kayake<\/h3><\/div><\/div><div style=\"flex: 0 0 auto; margin-left: auto;\"><a href=\"https:\/\/thelocalrent.com\/itemdetail\/35\" class=\"btn btn-outline-dark\">View<\/a><\/div><\/div><div style=\"padding: 10px; background: whitesmoke;margin-top: -10px; width:100%;\" class=\"shimmer\"><p style=\"margin: 0; color: #0090b4;\">Availability: <strong style=\"color: black;\">1<\/strong><\/p><p style=\"margin: 0; color: #0090b4;\">Pickup Dates: <strong style=\"color: black;\"><\/strong><\/p><\/div>",
//          "created_at":"2025-07-31T13:17:22.000000Z",
//          "updated_at":"2025-07-31T13:17:22.000000Z",
//          "fromuid":{
//             "id":1,
//             "image":"images\/Screenshot 2024-10-24 at 10.25.45 PM.png",
//             "activeUser":1,
//             "name":"John David",
//             "phone":"03012345678",
//             "email":"hasanameer386@gmail.com",
//             "address":"2452 Rooney Rd\r\nChattanooga , TN 21497",
//             "aboutUs":"Avid traveler \r\nEnjoy mountains and outdoors",
//             "verifiedBy":"google",
//             "sendEmail":1,
//             "password":"12345678",
//             "created_at":"2024-10-09T03:03:27.000000Z",
//             "updated_at":"2024-12-09T07:16:02.000000Z",
//             "deleted_at":null
//          }
//       },
//       {
//          "id":49,
//          "from":49,
//          "to":1,
//          "title":"New Booking for Vintage Type Writer",
//          "desc":"<div style=\"display: flex; padding: 15px; background: white; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); border-radius: 8px; margin-bottom: 10px; align-items: center;\" class=\"shimmer\"><div style=\"flex: 1; display: flex; align-items: center;\"><img src=\"https:\/\/thelocalrent.com\/uploads\/images\/Screenshot 2024-10-24 at 10.07.22 PM_1.png\" alt=\"Product Image\" style=\"width: 100px; height: 100px; border-radius: 8px; margin-right: 15px;\"\/><div><h3 style=\"margin: 0;\">Vintage Type Writer<\/h3><\/div><\/div><div style=\"flex: 0 0 auto; margin-left: auto;\"><a href=\"https:\/\/thelocalrent.com\/itemdetail\/28\" class=\"btn btn-outline-dark\">View<\/a><\/div><\/div><div style=\"padding: 10px; background: whitesmoke;margin-top: -10px; width:100%;\" class=\"shimmer\"><p style=\"margin: 0; color: #0090b4;\">Availability: <strong style=\"color: black;\">sadf<\/strong><\/p><p style=\"margin: 0; color: #0090b4;\">Pickup Dates: <strong style=\"color: black;\"><\/strong><\/p><\/div>",
//          "created_at":"2025-02-17T17:48:59.000000Z",
//          "updated_at":"2025-02-17T17:48:59.000000Z",
//          "fromuid":{
//             "id":49,
//             "image":"images\/dp.png",
//             "activeUser":1,
//             "name":"Ashley",
//             "phone":"4077179656",
//             "email":"ashleyd922@aol.com",
//             "address":"290 Stoner rd",
//             "aboutUs":null,
//             "verifiedBy":"google",
//             "sendEmail":1,
//             "password":"Peter1805!",
//             "created_at":"2025-02-17T17:41:56.000000Z",
//             "updated_at":"2025-02-17T17:41:56.000000Z",
//             "deleted_at":null
//          }
//       },
//       {
//          "id":46,
//          "from":32,
//          "to":1,
//          "title":"New Booking for Vintage Type Writer",
//          "desc":"<div style=\"display: flex; padding: 15px; background: white; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); border-radius: 8px; margin-bottom: 10px; align-items: center;\" class=\"shimmer\"><div style=\"flex: 1; display: flex; align-items: center;\"><img src=\"https:\/\/thelocalrent.com\/uploads\/images\/Screenshot 2024-10-24 at 10.07.22 PM_1.png\" alt=\"Product Image\" style=\"width: 100px; height: 100px; border-radius: 8px; margin-right: 15px;\"\/><div><h3 style=\"margin: 0;\">Vintage Type Writer<\/h3><\/div><\/div><div style=\"flex: 0 0 auto; margin-left: auto;\"><a href=\"https:\/\/thelocalrent.com\/itemdetail\/28\" class=\"btn btn-outline-dark\">View<\/a><\/div><\/div><div style=\"padding: 10px; background: whitesmoke;margin-top: -10px; width:100%;\" class=\"shimmer\"><p style=\"margin: 0; color: #0090b4;\">Availability: <strong style=\"color: black;\">sadf<\/strong><\/p><p style=\"margin: 0; color: #0090b4;\">Pickup Dates: <strong style=\"color: black;\"><\/strong><\/p><\/div>",
//          "created_at":"2024-12-19T17:52:09.000000Z",
//          "updated_at":"2024-12-19T17:52:09.000000Z",
//          "fromuid":{
//             "id":32,
//             "image":"images\/Screenshot 2024-08-31 at 10.46.28 AM.png",
//             "activeUser":1,
//             "name":"Ashley A.",
//             "phone":"4077179656",
//             "email":"Ashleyd9221@gmail.com",
//             "address":"290 smurf rd",
//             "aboutUs":"Southern Momma, I have lots of baby items.",
//             "verifiedBy":"google",
//             "sendEmail":1,
//             "password":"Peter1805!",
//             "created_at":"2024-10-25T03:25:00.000000Z",
//             "updated_at":"2024-10-25T05:04:13.000000Z",
//             "deleted_at":null
//          }
//       },
//       {
//          "id":45,
//          "from":32,
//          "to":1,
//          "title":"New Booking for Kayake",
//          "desc":"<div style=\"display: flex; padding: 15px; background: white; box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); border-radius: 8px; margin-bottom: 10px; align-items: center;\" class=\"shimmer\"><div style=\"flex: 1; display: flex; align-items: center;\"><img src=\"https:\/\/thelocalrent.com\/uploads\/images\/12.png\" alt=\"Product Image\" style=\"width: 100px; height: 100px; border-radius: 8px; margin-right: 15px;\"\/><div><h3 style=\"margin: 0;\">Kayake<\/h3><\/div><\/div><div style=\"flex: 0 0 auto; margin-left: auto;\"><a href=\"https:\/\/thelocalrent.com\/itemdetail\/35\" class=\"btn btn-outline-dark\">View<\/a><\/div><\/div><div style=\"padding: 10px; background: whitesmoke;margin-top: -10px; width:100%;\" class=\"shimmer\"><p style=\"margin: 0; color: #0090b4;\">Availability: <strong style=\"color: black;\">1<\/strong><\/p><p style=\"margin: 0; color: #0090b4;\">Pickup Dates: <strong style=\"color: black;\"><\/strong><\/p><\/div>",
//          "created_at":"2024-10-25T13:47:49.000000Z",
//          "updated_at":"2024-10-25T13:47:49.000000Z",
//          "fromuid":{
//             "id":32,
//             "image":"images\/Screenshot 2024-08-31 at 10.46.28 AM.png",
//             "activeUser":1,
//             "name":"Ashley A.",
//             "phone":"4077179656",
//             "email":"Ashleyd9221@gmail.com",
//             "address":"290 smurf rd",
//             "aboutUs":"Southern Momma, I have lots of baby items.",
//             "verifiedBy":"google",
//             "sendEmail":1,
//             "password":"Peter1805!",
//             "created_at":"2024-10-25T03:25:00.000000Z",
//             "updated_at":"2024-10-25T05:04:13.000000Z",
//             "deleted_at":null
//          }
//       }
//    ]
// }