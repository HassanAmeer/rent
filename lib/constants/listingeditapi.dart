import 'dart:convert';
import 'package:http/http.dart' as http;

class UserApi {
  static const String baseUrl = "https://thelocalrent.com/api";

  // ✅ Get User by ID
  static Future<Map<String, dynamic>?> getUserById(String id) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/getuserbyid/$id"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic>) {
          return data;
        }
      }
      return null;
    } catch (e) {
      print("❌ Error fetching user: $e");
      return null;
    }
  }
}
