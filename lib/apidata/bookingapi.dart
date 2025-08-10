// import '../main.dart';

// // Use the correct class name in the provider
// final listingDataProvider = ChangeNotifierProvider<ListingData>(
//   (ref) => ListingData(),
// );

// class ListingData with ChangeNotifier {
//   var listings = [];

//   //////
//   bool isLoading = false;
//   setLoading(bool value) {
//     isLoading = value;
//     notifyListeners();
//   }

//   fetchMyItems({required String uid}) async {
//     try {
//       print("Fetching my items for user ID: $uid");
//       final response = await http.get(
//         Uri.parse("https://thelocalrent.com/api/myitems/$uid"),
//       );

//       final data = jsonDecode(response.body);

//       print("👉Response status: ${response.statusCode}");
//       print("👉 data: $data");
//       if (response.statusCode == 200) {
//         listings = data['items'] ?? [];
//         // listings =  [];

//         notifyListeners();
//       } else {
//         toast(data['msg']);
//       }
//     } catch (e) {
//       print("Error fetching my items: $e");
//     }
//   }
