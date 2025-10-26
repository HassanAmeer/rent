import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rent/constants/api_endpoints.dart';
import 'package:rent/constants/checkInternet.dart';
import 'package:rent/services/toast.dart'; // Apne toast function ke liye import
import 'package:rent/models/rent_out_model.dart';

final rentOutProvider = ChangeNotifierProvider<RentOutProvider>(
  (ref) => RentOutProvider(),
);

class RentOutProvider with ChangeNotifier {
  List<BookingModel> comingOrders = [];
  // bool isLoading = false;
  String loadingfor = "";
  setLoading([String value = ""]) {
    loadingfor = value;
    notifyListeners();
  }

  // 1. Get Coming Orders API
  Future<void> fetchComingOrders({
    required String uid,
    var search = "",
    var loadingfor = "",
    bool refresh = false,
  }) async {
    setLoading(loadingfor);
    try {
      if (await checkInternet() == false) return;
      if (comingOrders.isNotEmpty && !refresh) return;

      setLoading(loadingfor);
      final response = await http.post(
        Uri.parse(Api.comingOrdersEndpoint),
        body: {"uid": uid, "search": search},
      );

      final data = jsonDecode(response.body);
      debugPrint("👉 Coming Orders Status: ${response.statusCode}");
      debugPrint("👉 Coming Orders Data: $data");

      if (response.statusCode == 200 && data['success'] == true) {
        final ordersData = data['commingOrders'] ?? [];
        comingOrders = ordersData
            .map<BookingModel>((order) => BookingModel.fromJson(order))
            .toList();
        notifyListeners();
      } else {
        comingOrders = [];
        toast(
          data['msg'] ?? "Failed to fetch coming orders",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      debugPrint("Error fetching coming orders: $e");
      toast("Error fetching coming orders", backgroundColor: Colors.red);
    } finally {
      setLoading("");
    }
  }

  // 2. Order Rejection API - Assuming it's a POST or PUT request
  // Please confirm HTTP method and required parameters; here assumed POST with orderId and userId
  Future<void> updateOrderStatus({
    String loadingFor = "",
    required String userId,
    required String orderId,
    required String statusId,
  }) async {
    setLoading("");
    try {
      if (await checkInternet() == false) return;
      setLoading(loadingFor);

      final response = await http.post(
        Uri.parse(Api.updateOrderStatus),
        body: {'uid': userId, 'order_id': orderId, 'status_id': statusId},
      );

      final data = jsonDecode(response.body);
      debugPrint("👉 updateOrderStatus Response: $data");

      if (response.statusCode == 200) {
        toast(data['msg'] ?? "Status Updated!", backgroundColor: Colors.black);
      } else {
        toast(
          data['msg'] ?? "Failed to Status Updates!",
          backgroundColor: Colors.red,
        );
      }
    } catch (e, st) {
      debugPrint("updateOrderStatus Error: $e, st:$st");
      toast("Status Updation Failed!", backgroundColor: Colors.red);
    } finally {
      setLoading("");
    }
  }
}






////////
// {
//     "success": true,
//     "msg": "Comming Orders Fetched",
//     "commingOrders": [
//         {
//             "id": 2,
//             "orderbyuid": 1,
//             "userCanPickupInDateRange": "0",
//             "totalPriceByUser": 0,
//             "deliverd": 1,
//             "isRejected": 0,
//             "productId": 1,
//             "product_by": 1,
//             "productTitle": "ultrapod",
//             "productImage":"[\"images\\/Screenshot 2024-10-03 at 5.52.57\ AM.png\",\"images\\/Screenshot 2024-10-03 at 6.00.40\ AM.png\"]",
//             "dailyrate": "0",
//             "weeklyrate": "0",
//             "monthlyrate": "0",
//             "availability": "Tuesday: 01:59 To 03:57,Wednesday: 01:58 To 01:59,",
//             "productPickupDate": "2024-10-31 to 2024-10-02",
//             "ipAddress": "127.0.0.1",
//             "created_at": "2024-10-17T01:41:22.000000Z",
//             "updated_at": "2024-12-09T07:24:33.000000Z",
//             "deleted_at": null,
//             "orderby": {
//                 "id": 1,
//                 "image": "images/Screenshot 2024-10-24 at 10.25.45 PM.png",
//                 "activeUser": 1,
//                 "name": "hassan",
//                 "phone": "03012345678",
//                 "email": "hasanameer386@gmail.com",
//                 "address": "2452 Rooney Rd\r\nChattanooga , TN 21497",
//                 "aboutUs": "Avid traveler \r\nEnjoy mountains and outdoors",
//                 "verifiedBy": "google",
//                 "sendEmail": 0,
//                 "password": "12345678",
//                 "created_at": "2024-10-09T03:03:27.000000Z",
//                 "updated_at": "2025-08-09T13:28:53.000000Z",
//                 "deleted_at": null
//             }
//         },
//         {
//             "id": 3,
//             "orderbyuid": 1,
//             "userCanPickupInDateRange": "8 October 2024 To 10 October 2024",
//             "totalPriceByUser": 0,
//             "deliverd": 0,
//             "isRejected": 0,
//             "productId": 1,
//             "product_by": 1,
//             "productTitle": "ultrapod",
//             "productImage":"[\"images\\/Screenshot 2024-10-03 at 5.52.57\ AM.png\",\"images\\/Screenshot 2024-10-03 at 6.00.40\ AM.png\"]",
//             "dailyrate": "0",
//             "weeklyrate": "0",
//             "monthlyrate": "0",
//             "availability": "Tuesday: 01:59 To 03:57,Wednesday: 01:58 To 01:59,",
//             "productPickupDate": "2024-10-31 to 2024-10-02",
//             "ipAddress": "127.0.0.1",
//             "created_at": "2024-10-17T01:42:53.000000Z",
//             "updated_at": "2025-02-20T15:27:00.000000Z",
//             "deleted_at": null,
//             "orderby": {
//                 "id": 1,
//                 "image": "images/Screenshot 2024-10-24 at 10.25.45 PM.png",
//                 "activeUser": 1,
//                 "name": "hassan",
//                 "phone": "03012345678",
//                 "email": "hasanameer386@gmail.com",
//                 "address": "2452 Rooney Rd\r\nChattanooga , TN 21497",
//                 "aboutUs": "Avid traveler \r\nEnjoy mountains and outdoors",
//                 "verifiedBy": "google",
//                 "sendEmail": 0,
//                 "password": "12345678",
//                 "created_at": "2024-10-09T03:03:27.000000Z",
//                 "updated_at": "2025-08-09T13:28:53.000000Z",
//                 "deleted_at": null
//             }
//         },
//     ]
// }