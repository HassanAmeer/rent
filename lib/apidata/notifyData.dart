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
import 'package:rent/models/notification_model.dart';

// import '../main.dart';

final notifyData = ChangeNotifierProvider<NotifyData>((ref) => NotifyData());

class NotifyData with ChangeNotifier {
  //////
  String loadingFor = "";
  setLoading([String value = ""]) {
    loadingFor = value;
    notifyListeners();
  }

  List<NotificationModel> notify = [];
  Future getNotifyData({
    required String uid,
    String loadingFor = "",
    bool refresh = false,
  }) async {
    try {
      if (await checkInternet() == false) return;
      if (notify.isNotEmpty && refresh == false) return;

      setLoading(loadingFor);
      final response = await http.get(
        Uri.parse("${Api.notificationsEndpoint}$uid"),
      );
      debugPrint("👉 getNotifyData Response status: ${response.statusCode}");
      // log(" 👉 getNotifyData Response body: ${response.body}");
      var result = json.decode(response.body);
      // debugPrint("👉 Response: $result");

      if (response.statusCode == 200 || response.statusCode == 201) {
        // toast(result['msg']);
        List notificationsData = result['notifications'] ?? [];
        notify = notificationsData
            .map<NotificationModel>(
              (notification) => NotificationModel.fromJson(notification),
            )
            .toList();
      } else {
        toast(result['msg'], backgroundColor: Colors.red);
      }
      setLoading();
    } catch (e) {
      debugPrint("💥try catch fetching notify Error:$e");
      setLoading();
    } finally {
      setLoading();
    }
  }

  statusCode(response) {
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<void> deleteNotification({
    required String notificationId,
    required String uid,
    String loadingfor = "",
  }) async {
    try {
      if (await checkInternet() == false) return;

      // print("$loadingfor");
      setLoading(loadingfor);
      debugPrint("notificationId : $notificationId");
      // debugPrint("uid : $uid");

      final respnse = await http.delete(
        Uri.parse("${Api.deleteNotificationEndpoint}$notificationId"),
      );

      final data = jsonDecode(respnse.body);
      if (statusCode(respnse)) {
        toast(data['msg'], backgroundColor: Colors.green);
        notify.removeWhere((e) => e.id.toString() == notificationId);
      } else {
        toast(data['msg'], backgroundColor: Colors.red);
      }
      setLoading();
    } catch (e) {
      debugPrint("💥try catch deleteNotification Error:$e");
      setLoading();
    } finally {
      setLoading();
    }
  }
}
