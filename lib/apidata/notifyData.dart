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
import 'package:rent/services/cache_service.dart';

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
      final cacheKey = CacheService.generateKey('notifications', {'uid': uid});

      // ✅ Load from cache first
      final cachedData = CacheService.getCache(cacheKey);
      if (cachedData != null &&
          cachedData is Map &&
          cachedData['notifications'] is List) {
        notify = (cachedData['notifications'] as List)
            .map<NotificationModel>(
              (notification) => NotificationModel.fromJson(notification),
            )
            .toList();
        notifyListeners();
        debugPrint(
          '📦 Notifications loaded from cache: ${notify.length} items',
        );

        if (!refresh &&
            !CacheService.isCacheStale(cacheKey, maxAgeMinutes: 5)) {
          return;
        }
      } else {
        setLoading(loadingFor);
      }

      if (await checkInternet() == false) {
        if (cachedData == null) setLoading();
        return;
      }

      final response = await http.get(
        Uri.parse("${Api.notificationsEndpoint}$uid"),
      );
      debugPrint("👉 getNotifyData Response status: ${response.statusCode}");
      var result = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        await CacheService.saveCache(cacheKey, result);

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
