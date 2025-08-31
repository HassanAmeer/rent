import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/constants/checkInternet.dart';
import 'package:rent/constants/toast.dart';
import 'package:rent/models/getchatmodel.dart';

var chatClass = ChangeNotifierProvider<ChatApi>((ref) => ChatApi());

class ChatApi with ChangeNotifier {
  List chatedUsersList = []; // ✅ API se aaya list store hoga
  GetChatModel? usersChatingData;
  String loadingFor = "";

  setLoading([String loadingName = ""]) {
    loadingFor = loadingName;
    notifyListeners();
  }

  /// ✅ Fetch All Chats
  Future<void> chatedUsers({var loadingFor = "", required String uid}) async {
    try {
      if (await checkInternet() == false) return;

      setLoading(loadingFor);

      final response = await http.get(
        Uri.parse("https://thelocalrent.com/api/getchatedusers/$uid"),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        chatedUsersList = data['chatedUsers'] ?? []; // ✅ safe parsing
        setLoading();
      } else {
        toast(data['message'] ?? data['msg'] ?? 'Failed to fetch chats');
        setLoading();
      }
    } catch (e) {
      setLoading();
      debugPrint("Error fetching chats: $e");
    }
  }

  ////// ✅ Get User Messages
  Future getUserMsgs({
    required String senderId,
    required String recieverId,
    String loadingfor = "",
    required ScrollController scrollController,
  }) async {
    try {
      if (await checkInternet() == false) return;
      setLoading(loadingfor);

      final response = await http.post(
        Uri.parse("https://thelocalrent.com/api/getchats"),
        body: {"recieverId": recieverId, "senderId": senderId},
      );

      debugPrint("Response status: ${response.statusCode}");

      var result = json.decode(response.body);
      print("👉 Response: $result");

      usersChatingData = GetChatModel.fromJson(result);

      // /// ✅ model lagaya yahan
      // messagesList = reverseList
      //     .map<GetChatModel>((item) => GetChatModel.fromJson(item))
      //     .toList()
      //     .reversed
      //     .toList();

      // print("messagesList.length: ${messagesList.length}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      } else {
        toast(result['msg'], backgroundColor: Colors.red);
      }

      setLoading();
    } catch (e, st) {
      setLoading();
      debugPrint(" 💥 get msgs error: $e, st:$st");
    } finally {
      setLoading();
    }
  }

  sndingmsgs({
    required String senderId,
    required String recieverId,
    String loadingfor = "",
    required String msg,
    required String time,
    required ScrollController scrollController,
  }) async {
    try {
      if (await checkInternet() == false) return;

      setLoading(loadingfor);

      final response = await http.post(
        Uri.parse("https://thelocalrent.com/api/sendmsg"),
        body: {
          "recieverId": recieverId,
          "senderId": senderId,
          "msg": msg,
          "time": time,
        },
      );

      debugPrint("Response status: ${response.statusCode}");

      var result = json.decode(response.body);
      print("👉 Response: $result");

      if (response.statusCode == 200 || response.statusCode == 201) {
        setLoading();
        await getUserMsgs(
          recieverId: recieverId,
          senderId: senderId,
          scrollController: scrollController,
        );
      } else {
        toast("msg not sent!");
      }
      setLoading();
    } catch (e, st) {
      setLoading();
      debugPrint(" 💥 sendMsg function error: $e, st:$st");
    } finally {
      setLoading();
    }
  }

  void addLocalMessage(Map<String, String> map) {}
}
