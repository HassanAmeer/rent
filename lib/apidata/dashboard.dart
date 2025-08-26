// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:http/http.dart' as http;
// import 'package:rent/Auth/login.dart';
// import 'package:rent/Auth/profile_update_page.dart';
// import 'package:rent/Auth/profile_details_page.dart';
// import 'package:rent/constants/checkInternet.dart';
// import 'package:rent/constants/goto.dart';
// import 'package:rent/constants/toast.dart';
// import 'package:rent/design/home_page.dart';

// // import '../main.dart';

// // Use the correct class name in the provider
// final Dashboardprovider = ChangeNotifierProvider<Dashboard>(
//   (ref) => Dashboard(),
// );

// class Dashboard with ChangeNotifier {
//   //////
//   String loadingfor = "";
//   setLoading([String value = ""]) {
//     loadingfor = value;

//     notifyListeners();
//   }

//   dash({
//     required String uid,
//     var loadingfor = "",
//     var name = "",
//     var email = "",
//     var password = "",
//   }) async {
//     try {
//       setLoading(loadingfor);
//       print("Fetching my items for user ID: $uid");
//       final response = await http.get(
//         Uri.parse("https://thelocalrent.com/api/dashboard"),
//         // body: {'search': search, "uid": uid},
//       );
//       final data = jsonDecode(response.body);

//       print("👉Response status: ${response.statusCode}");
//       print("👉 data: $data");
//       if (response.statusCode == 200) {
//         // dash = data{
//         //   "user": {
//         //     "name": name
//         //     "email": email;
//         //     "password": password;
//         //     "uid": uid;
//         //   }
//         // }
//         // listings =  [];
//         setLoading("");
//         notifyListeners();
//       } else {
//         toast(data['msg']);
//         setLoading("");
//       }
//     } catch (e) {
//       setLoading("");
//       print("Error fetching my items: $e");
//     }
//   }
// }

//   //

