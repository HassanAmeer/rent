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

import '../models/docModel.dart';

// import '../main.dart';

final settingsProvider = ChangeNotifierProvider<SettingsDataClass>(
  (ref) => SettingsDataClass(),
);

class SettingsDataClass with ChangeNotifier {
  //////
  String loadingFor = "";
  setLoading([String value = ""]) {
    loadingFor = value;
    notifyListeners();
  }

  List settingsData = [];
  Future getSettingsData({required String uid, String loadingFor = ""}) async {
    try {
      if (await checkInternet() == false) return;
      setLoading(loadingFor);

      final response = await http.get(Uri.parse(Api.settingsEndpoint));

      var result = json.decode(response.body);
      debugPrint("👉 Response: $result");

      if (response.statusCode == 200 || response.statusCode == 201) {
        settingsData = result['settings'];
      } else {
        toast(result['msg'], backgroundColor: Colors.red);
      }
      setLoading();
    } catch (e, st) {
      debugPrint("💥 getSettingsData: error: $e, st$st");
      setLoading();
    } finally {
      setLoading();
    }
  }
  ////////////

  DocDataModel docData = DocDataModel(
    id: 00,
    privacyPolicy: "Not Found",
    shippingPolicy: "Not Found",
    returnRefundPolicy: "Not Found",
    termsCondition: "Not Found",
    contactUs: "Not Found",
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  Future getDocData({String loadingFor = ""}) async {
    try {
      if (await checkInternet() == false) return;

      if (docData.id == 00) {
        setLoading(loadingFor);
        final response = await http.get(Uri.parse(Api.docEndpoint));

        var result = json.decode(response.body);
        debugPrint("👉 Response: $result");

        if (response.statusCode == 200 || response.statusCode == 201) {
          docData = DocDataModel.fromJson(result['data']);
        } else {
          toast(result['msg'], backgroundColor: Colors.red);
        }
        setLoading();
      }
    } catch (e, st) {
      debugPrint("💥 getDocData: error: $e, st$st");
      setLoading();
    } finally {
      setLoading();
    }
  }
}
