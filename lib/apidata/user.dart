import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:rent/Auth/login.dart';
import 'package:rent/Auth/profile_update_page.dart';
import 'package:rent/Auth/profile_details_page.dart';
import 'package:rent/constants/checkInternet.dart';
import 'package:rent/constants/goto.dart';
import 'package:rent/constants/images.dart';
import 'package:rent/constants/toast.dart';
import 'package:rent/design/home_page.dart';

/// Provider for user data management
final userDataClass = ChangeNotifierProvider<UserData>((ref) => UserData());

/// Enhanced UserData class with better error handling and API management
class UserData with ChangeNotifier {
  Map<String, dynamic> _userData = {};
  bool _isLoading = false;
  String _errorMessage = '';

  /// Getters
  Map<String, dynamic> get userData => _userData;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isLoggedIn => _userData.isNotEmpty;
  String get userId => _userData['id']?.toString() ?? '';
  String get userName => _userData['name']?.toString() ?? '';
  String get userEmail => _userData['email']?.toString() ?? '';
  String get userImage => _userData['image']?.toString() ?? '';

  /// Load user data from local storage
  Future<void> getStorageData() async {
    try {
      await Hive.openBox("userBox");
      var box = Hive.box('userBox');
      var checkData = box.get('userData');
      if (checkData != null) {
        _userData = Map<String, dynamic>.from(checkData);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error loading user data from storage: $e");
      _errorMessage = "Failed to load user data";
      notifyListeners();
    }
  }

  /// Check if user is already logged in and navigate accordingly
  Future<void> checkAlreadyhaveLogin() async {
    try {
      await Hive.openBox("userBox");
      var box = Hive.box('userBox');
      var checkData = box.get('userData');
      if (checkData != null) {
        _userData = Map<String, dynamic>.from(checkData);
        notifyListeners();
        await Future.delayed(const Duration(milliseconds: 1000));
        navigateTo(const HomePage(), canBack: false, delayInMilliSeconds: 2000);
      } else {
        await Future.delayed(const Duration(milliseconds: 1000));
        navigateTo(
          const LoginPage(),
          canBack: false,
          delayInMilliSeconds: 2000,
        );
      }
    } catch (e) {
      debugPrint("Error checking login status: $e");
      navigateTo(const LoginPage(), canBack: false, delayInMilliSeconds: 2000);
    }
  }

  /// Logout user and clear data
  Future<void> logout() async {
    try {
      await Hive.openBox("userBox");
      var box = Hive.box('userBox');
      await box.delete('userData');
      _userData.clear();
      _errorMessage = '';
      notifyListeners();
      navigateTo(const LoginPage(), canBack: false, delayInMilliSeconds: 500);
    } catch (e) {
      debugPrint("Error during logout: $e");
      showErrorToast("Logout failed");
    }
  }

  /// Set loading state
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  /// Register new user with enhanced validation and error handling
  Future<void> register({String? name, String? email, String? password}) async {
    try {
      // Check internet connection
      if (await checkInternet() == false) {
        showErrorToast("No internet connection");
        return;
      }

      setLoading(true);

      // Validate input fields
      if (name == null || name.trim().isEmpty) {
        showErrorToast("Please enter your name");
        return;
      }

      if (email == null || email.trim().isEmpty) {
        showErrorToast("Please enter your email");
        return;
      }

      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        showErrorToast("Please enter a valid email address");
        return;
      }

      if (password == null || password.length < 6) {
        showErrorToast("Password must be at least 6 characters long");
        return;
      }

      // Make API call
      final response = await http.post(
        Uri.parse(Config.registerEndpoint),
        body: {
          'name': name.trim(),
          'email': email.trim(),
          'password': password,
        },
      );

      final data = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['success'] == true) {
          showSuccessToast(data['msg'] ?? "Registration successful");
          navigateTo(const LoginPage(), canBack: false);
        } else {
          _errorMessage =
              data['msg'] ??
              data['errors']?.toString() ??
              "Registration failed";
          showErrorToast(_errorMessage);
        }
      } else {
        _errorMessage = data['msg'] ?? "Registration failed";
        showErrorToast(_errorMessage);
      }
    } catch (e) {
      debugPrint("Registration error: $e");
      _errorMessage = "Network error during registration";
      showErrorToast(_errorMessage);
    } finally {
      setLoading(false);
    }
  }

  /// Login user with enhanced validation and error handling
  Future<void> login({required String email, required String password}) async {
    try {
      // Check internet connection
      // if (await checkInternet() == false) {
      //   showErrorToast("No internet connection");
      //   return;
      // }

      setLoading(true);

      // Validate input
      if (email.trim().isEmpty || password.trim().isEmpty) {
        showErrorToast("Please enter both email and password");
        return;
      }

      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        showErrorToast("Please enter a valid email address");
        return;
      }

      // Make API call
      final response = await http.post(
        Uri.parse(Config.loginEndpoint),
        body: {'email': email.trim(), 'password': password},
      );

      debugPrint("Login Response status: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = json.decode(response.body);

        if (result['success'] == true && result['user'] != null) {
          // Save user data to local storage
          final userData = Map<String, dynamic>.from(result['user']);
          final box = Hive.box('userBox');
          await box.put('userData', userData);

          // Update local state
          _userData = userData;
          notifyListeners();

          showSuccessToast(result['msg'] ?? "Login successful");
          navigateTo(const HomePage(), canBack: false);
        } else {
          _errorMessage = result['msg'] ?? "Login failed";
          showErrorToast(_errorMessage);
        }
      } else {
        final result = json.decode(response.body);
        _errorMessage = result['msg'] ?? "Login failed";
        showErrorToast(_errorMessage);
      }
    } catch (e) {
      debugPrint("Login error: $e");
      _errorMessage = "Network error during login";
      showErrorToast(_errorMessage);
    } finally {
      setLoading(false);
    }
  }
  /////////////// get profile data

  /// Fetch user profile data from API
  Future<void> getProfileData() async {
    try {
      if (await checkInternet() == false) return;

      if (_userData['id'] == null) {
        debugPrint("User ID not available for profile fetch");
        return;
      }

      setLoading(true);
      final response = await http.get(
        Uri.parse("${Config.getUserByIdEndpoint}${_userData['id']}"),
      );

      debugPrint("👉 Profile Data Response status: ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final result = json.decode(response.body);
        if (result['success'] == true && result['user'] != null) {
          _userData = Map<String, dynamic>.from(result['user']);
          notifyListeners();
          // Don't show toast here as it's called during init
        } else {
          _errorMessage = result['msg'] ?? "Failed to load profile";
          debugPrint("Profile fetch failed: $_errorMessage");
        }
      } else {
        _errorMessage = "Failed to load profile data";
        debugPrint("Profile fetch failed: $_errorMessage");
      }
    } catch (e) {
      debugPrint("Error fetching profile data: $e");
      _errorMessage = "Network error while loading profile";
    } finally {
      setLoading(false);
    }
  }

  /// Update user profile with enhanced error handling
  Future<void> updateProfile({
    required String name,
    required String phone,
    required String email,
    required String aboutUs,
    required String address,
    String imagePath = "",
  }) async {
    try {
      if (await checkInternet() == false) {
        showErrorToast("No internet connection");
        return;
      }

      if (name.trim().isEmpty || email.trim().isEmpty) {
        showErrorToast("Name and email are required");
        return;
      }

      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        showErrorToast("Please enter a valid email address");
        return;
      }

      setLoading(true);
      var req = http.MultipartRequest(
        "POST",
        Uri.parse(Config.updateProfileEndpoint),
      );

      req.headers['Content-Type'] = 'application/json';

      req.fields['uid'] = _userData['id'].toString();
      req.fields['name'] = name.trim();
      req.fields['phone'] = phone.trim();
      req.fields['email'] = email.trim();
      req.fields['aboutUs'] = aboutUs.trim();
      req.fields['address'] = address.trim();

      if (imagePath.isNotEmpty) {
        req.files.add(await http.MultipartFile.fromPath('image', imagePath));
      }

      var streamedResponse = await req.send();
      var response = await streamedResponse.stream.bytesToString();

      debugPrint(
        "Update Profile Response status: ${streamedResponse.statusCode}",
      );

      if (streamedResponse.statusCode == 200 ||
          streamedResponse.statusCode == 201) {
        final result = json.decode(response);
        if (result['success'] == true) {
          // Refresh profile data
          await getProfileData();
          showSuccessToast("Profile updated successfully");
          navigateTo(const ProfileDetailsPage(), canBack: false);
        } else {
          _errorMessage = result['msg'] ?? "Failed to update profile";
          showErrorToast(_errorMessage);
        }
      } else {
        _errorMessage = "Failed to update profile";
        showErrorToast(_errorMessage);
      }
    } catch (e) {
      debugPrint("Error updating profile: $e");
      _errorMessage = "Network error while updating profile";
      showErrorToast(_errorMessage);
    } finally {
      setLoading(false);
    }
  }

  /// Legacy method - kept for backward compatibility
  static fetchMyItems() {}
}



















// {
//    "success":true,
//    "msg":"Login successful",
//    "user":{
//       "id":68,
//       "image":"images/dp.png",
//       "activeUser":1,
//       "name":"hasanameer",
//       "phone":null,
//       "email":"hassanameer@gmail.com",
//       "address":null,\
//       "aboutUs":null,
//       "verifiedBy":"google",
//       "sendEmail":1,
//       "password":12345678,
//       "created_at":"2025-08-06T09":"43":26.000000Z,
//       "updated_at":"2025-08-06T09":"43":26.000000Z,
//       "deleted_at":null
//    }
// }