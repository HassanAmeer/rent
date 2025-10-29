import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/constants/api_endpoints.dart';
import 'package:rent/constants/checkInternet.dart';
import 'package:rent/services/toast.dart';

import '../models/chat_model.dart';
import '../models/chatedUsersModel.dart';

var chatClass = ChangeNotifierProvider<ChatApi>((ref) => ChatApi());

class ChatApi with ChangeNotifier {
  List<ChatedUsersModel> chatedUsersList = []; // ✅ API se aaya list store hoga
  ChatModel? messagesData;
  String loadingFor = "";

  setLoading([String loadingName = ""]) {
    loadingFor = loadingName;
    notifyListeners();
  }

  /// ✅ Fetch All Chats
  Future<void> chatedUsers({
    var loadingFor = "",
    required String uid,
    bool refresh = false,
  }) async {
    try {
      if (await checkInternet() == false) return;
      if (chatedUsersList.isNotEmpty && refresh == false) return;

      setLoading(loadingFor);

      final response = await http.get(
        Uri.parse("${Api.getChatedUsersEndpoint}$uid"),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        List chatedList = data['chatedUsers'] ?? [];
        // ✅ safe parsing
        chatedUsersList = chatedList
            .map((e) => ChatedUsersModel.fromJson(e))
            .toList();
        // debugPrint("👉 Response chatedUsersList: $chatedUsersList");

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

  //////
  Future getUserMsgs({
    required String senderId,
    required String recieverId,
    String loadingfor = "",
    required ScrollController scrollController,
  }) async {
    try {
      // 🔹 Step 1: Internet check karo
      if (await checkInternet() == false) return;
      setLoading(loadingfor);
      // 🔹 Step 2: API call
      final response = await http.post(
        Uri.parse(Api.getChatsEndpoint),
        body: {"recieverId": recieverId, "senderId": senderId},
      );

      debugPrint("Response status: ${response.statusCode}");

      var result = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // log("👉 getUserMsgs Response: $result");
        // List chatList = result['chats'];
        // messagesData = chatList
        //     .map((e) => ChatModel.fromJson(e))
        //     .toList()
        //     .reversed
        //     .toList();
        messagesData = ChatModel.fromJson(result);
        // toast(result['msg'], backgroundColor: Colors.green);
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

  sendingOrCreatingmsg({
    required String senderId,
    required String recieverId,
    String loadingfor = "",
    required String msg,
    required String time,
    required ScrollController scrollController,
  }) async {
    try {
      // 🔹 Step 1: Internet check karo
      if (await checkInternet() == false) return;

      setLoading(loadingfor);

      // 🔹 Step 2: API call
      final response = await http.post(
        Uri.parse(Api.sendMsgEndpoint),
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
