import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = "https://dummyjson.com/users";

  static Future<List<Map<String, dynamic>>> fetchListings() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        log("API Response: ${decoded['users']}");
        return List<Map<String, dynamic>>.from(decoded['users']);
      }
    } catch (e) {
      print("API error: $e");
    }
    return [];
  }
}
