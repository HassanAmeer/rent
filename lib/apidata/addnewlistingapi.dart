import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/constants/toast.dart';

// ✅ Provider for Listings
final listingDataProvider = ChangeNotifierProvider<ListingData>(
  (ref) => ListingData(),
);

class ListingData with ChangeNotifier {
  String loadingFor = "";
  bool isLoading = false;

  void setLoading(bool value, [String loadingName = ""]) {
    loadingFor = loadingName;
    isLoading = value;
    notifyListeners();
  }

  /// ✅ Add New Listing
  Future<void> addNewListing({
    required String uid,
    required String title,
    required String catgname,
    required String dailyRate,
    required String weeklyRate,
    required String monthlyRate,
    required String availabilityDays,
    required String description,
    List images = const [],
  }) async {
    try {
      setLoading(true);
      var req = http.MultipartRequest(
        "POST",
        Uri.parse("https://thelocalrent.com/api/additem"),
      );

      req.headers['Content-Type'] = 'application/json';

      //// for fields
      req.fields['uid'] = uid;
      req.fields['title'] = title;
      req.fields['catgname'] = catgname.toString();
      req.fields['weekly_rate'] = weeklyRate;
      req.fields['availabilityDays'] = availabilityDays;
      req.fields['description'] = description;
      req.fields['monthly_rate'] = monthlyRate;
      req.fields['dailyRate'] = dailyRate;

      // for files
      if (images.isNotEmpty) {
        for (var i = 0; i < images.length; i++) {
          final imagePath =
              images[i].path; // Agar `XFile` ya `File` use kar rhy ho
          req.files.add(
            await http.MultipartFile.fromPath(
              'images[]', // ✅ Backend agar multiple images array accept kare
              imagePath,
            ),
          );
        }
      }

      var sendedRequest = await req.send();
      var response = await sendedRequest.stream.bytesToString();

      debugPrint("😊 sendedRequest status: ${sendedRequest.statusCode}");
      debugPrint("😊 response data: ${response}");

      if (sendedRequest.statusCode == 200 || sendedRequest.statusCode == 201) {
        toast("Successfully Added", backgroundColor: Colors.green);
      } else {
        toast("Failed to upload", backgroundColor: Colors.red);
      }

      setLoading(false);
    } catch (e) {
      setLoading(false);
      debugPrint("Error adding listing: $e");
      toast("Network error: Please check your connection");
    }
  }
}
