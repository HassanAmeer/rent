import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/Auth/login.dart';
import 'package:rent/Auth/profile_update_page.dart';
import 'package:rent/Auth/profile_details_page.dart';
import 'package:rent/constants/checkInternet.dart';
import 'package:rent/constants/goto.dart';
import 'package:rent/constants/toast.dart';
import 'package:rent/design/home_page.dart';

final userDataClass = ChangeNotifierProvider<UserData>((ref) => UserData());

class UserData with ChangeNotifier {
  var userdata = {};

  getStorageData() async {
    await Hive.openBox("userBox");
    var box = Hive.box('userBox'); // File Name
    var checkData = box.get('userData'); // save the user object (map) data
    if (checkData != null) {
      userdata = checkData;
      notifyListeners();
      // print("user dtaa from hive box: $checkData");
    }
  }
  
  checkAlreadyhaveLogin() async{
    await Hive.openBox("userBox");
    var box = Hive.box('userBox'); // File Name
    var checkData = box.get('userData'); // save the user object (map) data
    if (checkData != null) {
      userdata = checkData;
      notifyListeners();
      await Future.delayed(Duration(milliseconds: 1000));
      goto(HomePage(), delayInMilliSeconds: 2000, canBack: false);
    }else{
      await Future.delayed(Duration(milliseconds: 1000));
      goto(LoginPage(), delayInMilliSeconds: 2000, canBack: false);
    }
  }

  logout() async {
    await Hive.openBox("userBox");
    var box = Hive.box('userBox'); // File Name
    box.delete('userData');
    goto(LoginPage(), canBack: false, delayInMilliSeconds: 500);
  }

  //////
  bool isLoading = false;
  setLoading(bool value) {
    notifyListeners();
    isLoading = value;
    notifyListeners();
  }

  register({String? name, String? email, String? password}) async {
    try {
      // 🔹 Step 1: Internet check
      if (await checkInternet() == false) return;

      setLoading(true);
      notifyListeners();

      // 🔹 Step 2: Check fields
      if (name == null || email == null || password == null) {
        toast("Please fill all fields", backgroundColor: Colors.red);
        setLoading(false);
        return;
      }

      final url = Uri.parse('https://thelocalrent.com/api/register');

      // 🔹 Step 3: API call
      final response = await http.post(
        url,
        body: {'name': name, 'email': email, 'password': password},
      );

      final data = json.decode(response.body);

      setLoading(false);

      if (response.statusCode == 200 || response.statusCode == 201) {
        toast(
          data['msg'] ?? "Signup successful",
          backgroundColor: Colors.green,
        );
        goto(LoginPage(), canBack: false);
      } else {
        toast(data['errors'].toString(), backgroundColor: Colors.red);
      }
    } catch (e) {
      setLoading(false);
      toast("Error: $e", backgroundColor: Colors.red);
    }
  }

  Future login({required String email, required String password}) async {
    try {
      // 🔹 Step 1: Internet check karo
      if (await checkInternet() == false) return;

      setLoading(true);

      // 🔹 Step 2: API call
      final response = await http.post(
        Uri.parse("https://thelocalrent.com/api/login"),
        body: {'email': email, 'password': password},
      );

      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      var result = json.decode(response.body);
      print("👉 Response: $result");

      setLoading(false);

      if (response.statusCode == 200 || response.statusCode == 201) {
        toast(result['msg'], backgroundColor: Colors.green);

        var userdata = result['user'];

        var box = Hive.box('userBox');
        box.put('userData', userdata);

        goto(const HomePage(), canBack: false);
      } else {
        toast(result['msg'], backgroundColor: Colors.red);
      }
    } catch (e, st) {
      print(" 👉 login error: $e, st:$st");
      setLoading(false);
    }
  }
  /////////////// get profile data

  Future getProfileData() async {
    try {
      if (await checkInternet() == false) return;

      setLoading(true);
      final response = await http.get(
        Uri.parse("https://thelocalrent.com/api/getuserbyid/${userdata['id']}"),
      );
      debugPrint("👉 Response status: ${response.statusCode}");
      debugPrint(" 👉 Response body: ${response.body}");
      var result = json.decode(response.body);
      print("👉 Response: $result");

      setLoading(false);
      if (response.statusCode == 200 || response.statusCode == 201) {
        userdata = result['user'];
      } else {
        toast(result['msg'], backgroundColor: Colors.red);
      }
      setLoading(false);
    } catch (e) {
      setLoading(false);
    }
  }

  Future updateProfile({
    required String name,
    required String phone,
    required String email,
    required String aboutUs,
    required String address,
    String imagePath = "",
  }) async {
    try {
      if (await checkInternet() == false) return;

      ////
      setLoading(true);
      var req = http.MultipartRequest(
        "POST",
        Uri.parse("https://thelocalrent.com/api/updateprofile"),
      );

      req.headers['Content-Type'] = 'application/json';

      req.fields['uid'] = userdata['id'].toString();
      req.fields['name'] = name;
      req.fields['phone'] = phone.toString();
      req.fields['email'] = email;
      req.fields['aboutUs'] = aboutUs;
      req.fields['address'] = address;

      if (imagePath.isNotEmpty) {
        req.files.add(await http.MultipartFile.fromPath('image', imagePath));
      }

      var sendedRequest = await req.send();
      var response = await sendedRequest.stream.bytesToString();

      debugPrint("😊 sendedRequest status: ${sendedRequest.statusCode}");
      debugPrint("😊 response data: $response");

      if (sendedRequest.statusCode == 200 || sendedRequest.statusCode == 201) {
        toast("Successfully updated", backgroundColor: Colors.green);
        getProfileData();

        setLoading(false);
        goto(const ProfileDetailsPage(), canBack: false);
      } else {
        toast("Failed to update", backgroundColor: Colors.red);
      }
      setLoading(false);
    } catch (e) {
      setLoading(false);
    }
  }

  static fetchMyItems() {}
}



















// {
//    "success":true,
//    "msg":"Login successful",
//    "user":{
//       "id":68,
//       "image":"images/dp.png",
//       "activeUser":1,
//       "name":"hasanameer",
//       "phone":null,
//       "email":"hassanameer@gmail.com",
//       "address":null,\
//       "aboutUs":null,
//       "verifiedBy":"google",
//       "sendEmail":1,
//       "password":12345678,
//       "created_at":"2025-08-06T09":"43":26.000000Z,
//       "updated_at":"2025-08-06T09":"43":26.000000Z,
//       "deleted_at":null
//    }
// }