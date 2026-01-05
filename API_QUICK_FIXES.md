# 🚀 API Connection Quick Fixes & Optimizations

## 🎯 Immediate Improvements to Apply

### 1. ✅ Add Global API Service Class

Create `lib/services/api_service.dart`:

```dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:rent/constants/api_endpoints.dart';
import 'package:rent/constants/checkInternet.dart';
import 'package:rent/services/toast.dart';

class ApiService {
  // Timeout duration
  static const Duration _timeout = Duration(seconds: 30);
  
  // Standard headers
  static Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// GET Request with error handling
  static Future<http.Response?> get(
    String url, {
    bool showError = true,
    bool checkConnection = true,
  }) async {
    try {
      if (checkConnection && await checkInternet() == false) {
        if (showError) showErrorToast('No internet connection');
        return null;
      }

      debugPrint('📤 GET: $url');
      
      final response = await http
          .get(Uri.parse(url), headers: _headers)
          .timeout(_timeout);

      debugPrint('📥 Response ${response.statusCode}: ${url}');
      
      return response;
    } on SocketException {
      if (showError) showErrorToast('Network error. Please check your connection');
      debugPrint('❌ SocketException: $url');
      return null;
    } on TimeoutException {
      if (showError) showErrorToast('Request timed out. Please try again');
      debugPrint('❌ TimeoutException: $url');
      return null;
    } catch (e) {
      if (showError) showErrorToast('An error occurred');
      debugPrint('❌ Error: $e');
      return null;
    }
  }

  /// POST Request with error handling
  static Future<http.Response?> post(
    String url, {
    Map<String, dynamic>? body,
    bool showError = true,
    bool checkConnection = true,
  }) async {
    try {
      if (checkConnection && await checkInternet() == false) {
        if (showError) showErrorToast('No internet connection');
        return null;
      }

      debugPrint('📤 POST: $url');
      debugPrint('📦 Body: $body');
      
      final response = await http
          .post(
            Uri.parse(url),
            headers: _headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeout);

      debugPrint('📥 Response ${response.statusCode}: ${url}');
      
      return response;
    } on SocketException {
      if (showError) showErrorToast('Network error. Please check your connection');
      debugPrint('❌ SocketException: $url');
      return null;
    } on TimeoutException {
      if (showError) showErrorToast('Request timed out. Please try again');
      debugPrint('❌ TimeoutException: $url');
      return null;
    } catch (e) {
      if (showError) showErrorToast('An error occurred');
      debugPrint('❌ Error: $e');
      return null;
    }
  }

  /// DELETE Request with error handling
  static Future<http.Response?> delete(
    String url, {
    bool showError = true,
    bool checkConnection = true,
  }) async {
    try {
      if (checkConnection && await checkInternet() == false) {
        if (showError) showErrorToast('No internet connection');
        return null;
      }

      debugPrint('📤 DELETE: $url');
      
      final response = await http
          .delete(Uri.parse(url), headers: _headers)
          .timeout(_timeout);

      debugPrint('📥 Response ${response.statusCode}: ${url}');
      
      return response;
    } on SocketException {
      if (showError) showErrorToast('Network error. Please check your connection');
      debugPrint('❌ SocketException: $url');
      return null;
    } on TimeoutException {
      if (showError) showErrorToast('Request timed out. Please try again');
      debugPrint('❌ TimeoutException: $url');
      return null;
    } catch (e) {
      if (showError) showErrorToast('An error occurred');
      debugPrint('❌ Error: $e');
      return null;
    }
  }

  /// Parse JSON response safely
  static Map<String, dynamic>? parseResponse(http.Response? response) {
    if (response == null) return null;
    
    try {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('❌ JSON Parse Error: $e');
      return null;
    }
  }

  /// Check if response is successful
  static bool isSuccess(http.Response? response) {
    return response != null && 
           response.statusCode >= 200 && 
           response.statusCode < 300;
  }

  /// Handle standard API error response
  static void handleError(Map<String, dynamic>? data, {String? fallback}) {
    final message = data?['msg'] ?? 
                    data?['message'] ?? 
                    data?['error'] ?? 
                    fallback ?? 
                    'An error occurred';
    showErrorToast(message);
  }
}
```

---

### 2. ✅ Update Blog API to Use Service

Update `lib/apidata/blogapi.dart`:

```dart
import 'package:rent/services/api_service.dart';

class BlogData with ChangeNotifier {
  // ... existing code ...

  /// Fetch All Blogs - IMPROVED
  Future<void> fetchAllBlogs({
    String loadingFor = "",
    String search = "",
    bool refresh = false,
  }) async {
    try {
      if (blogs.isNotEmpty && !refresh) return;

      setLoading(loadingFor);
      
      final response = await ApiService.get(Api.allBlogsEndpoint);
      
      if (ApiService.isSuccess(response)) {
        final data = ApiService.parseResponse(response);
        
        if (data != null && data['blogs'] != null) {
          blogs.clear();
          List blogsData = data['blogs'];
          blogs = blogsData
              .map<BlogModel>((blog) => BlogModel.fromJson(blog))
              .toList();
          
          debugPrint('✅ Loaded ${blogs.length} blogs');
        }
      } else {
        final data = ApiService.parseResponse(response);
        ApiService.handleError(data, fallback: 'Failed to fetch blogs');
      }
    } catch (e) {
      debugPrint("❌ Error fetching blogs: $e");
      showErrorToast('Error loading blogs');
    } finally {
      setLoading();
      notifyListeners();
    }
  }

  /// Fetch Blog Details by ID - IMPROVED
  Future<void> fetchBlogDetails({
    required String blogId,
    String loadingFor = "",
  }) async {
    try {
      setLoading(loadingFor);
      
      final response = await ApiService.get(
        "${Api.blogDetailsEndpoint}$blogId",
      );
      
      if (ApiService.isSuccess(response)) {
        final data = ApiService.parseResponse(response);
        
        if (data != null) {
          final blogData = data['blog'] ?? 
                          data['blogDetails'] ?? 
                          data['data'] ?? 
                          {};
          
          if (blogData.isNotEmpty) {
            blogDetails = BlogModel.fromJson(blogData);
            debugPrint('✅ Loaded blog: ${blogDetails?.title}');
          }
        }
      } else {
        final data = ApiService.parseResponse(response);
        ApiService.handleError(data, fallback: 'Failed to fetch blog details');
      }
    } catch (e) {
      debugPrint("❌ Error fetching blog details: $e");
      showErrorToast('Error loading blog');
    } finally {
      setLoading();
      notifyListeners();
    }
  }
}
```

---

### 3. ✅ Add Caching for Better Performance

Create `lib/services/cache_service.dart`:

```dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static SharedPreferences? _prefs;

  /// Initialize cache
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Save data with expiry
  static Future<void> save({
    required String key,
    required dynamic data,
    Duration validity = const Duration(minutes: 30),
  }) async {
    await init();
    final cacheData = {
      'data': data,
      'expiry': DateTime.now().add(validity).toIso8601String(),
    };
    await _prefs!.setString(key, jsonEncode(cacheData));
  }

  /// Get cached data if not expired
  static Future<T?> get<T>(String key) async {
    await init();
    final cached = _prefs!.getString(key);
    
    if (cached == null) return null;
    
    try {
      final cacheData = jsonDecode(cached);
      final expiry = DateTime.parse(cacheData['expiry']);
      
      if (DateTime.now().isBefore(expiry)) {
        return cacheData['data'] as T;
      } else {
        // Expired - remove it
        await _prefs!.remove(key);
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// Clear specific cache
  static Future<void> clear(String key) async {
    await init();
    await _prefs!.remove(key);
  }

  /// Clear all cache
  static Future<void> clearAll() async {
    await init();
    await _prefs!.clear();
  }
}
```

Use caching in APIs:

```dart
/// In BlogData class
Future<void> fetchAllBlogs({bool refresh = false}) async {
  // Try cache first
  if (!refresh) {
    final cached = await CacheService.get<List>('blogs');
    if (cached != null) {
      blogs = cached.map((e) => BlogModel.fromJson(e)).toList();
      notifyListeners();
      return;
    }
  }
  
  // Fetch from API
  final response = await ApiService.get(Api.allBlogsEndpoint);
  
  if (ApiService.isSuccess(response)) {
    final data = ApiService.parseResponse(response);
    // ... parse blogs ...
    
    // Save to cache
    await CacheService.save(
      key: 'blogs',
      data: blogs.map((e) => e.toJson()).toList(),
      validity: Duration(minutes: 30),
    );
  }
}
```

---

### 4. ✅ Add Retry Logic for Failed Requests

Add to `lib/services/api_service.dart`:

```dart
class ApiService {
  // ... existing code ...

  /// Retry a request on failure
  static Future<T?> retry<T>(
    Future<T?> Function() request, {
    int maxRetries = 3,
    Duration delay = const Duration(seconds: 2),
  }) async {
    for (int i = 0; i < maxRetries; i++) {
      try {
        final result = await request();
        if (result != null) return result;
      } catch (e) {
        if (i == maxRetries - 1) {
          debugPrint('❌ Max retries ($maxRetries) reached');
          rethrow;
        }
        debugPrint('⚠️ Retry ${i + 1}/$maxRetries after error: $e');
        await Future.delayed(delay * (i + 1));
      }
    }
    return null;
  }
}

// Usage:
final response = await ApiService.retry(() async {
  return await ApiService.get(Api.allBlogsEndpoint);
});
```

---

### 5. ✅ Add Loading Overlay Service

Create `lib/services/loading_service.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingService {
  static OverlayEntry? _overlay;
  static BuildContext? _context;

  /// Show loading overlay
  static void show(BuildContext context, {String? message}) {
    if (_overlay != null) return; // Already showing

    _context = context;
    _overlay = OverlayEntry(
      builder: (context) => Material(
        color: Colors.black54,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SpinKitFadingCircle(
                color: Colors.white,
                size: 50.0,
              ),
              if (message != null) ...[
                SizedBox(height: 16),
                Text(
                  message,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    Overlay.of(context)?.insert(_overlay!);
  }

  /// Hide loading overlay
  static void hide() {
    _overlay?.remove();
    _overlay = null;
    _context = null;
  }
}

// Usage in API calls:
LoadingService.show(context, message: 'Loading blogs...');
await blogData.fetchAllBlogs();
LoadingService.hide();
```

---

### 6. ✅ Add Pull-to-Refresh for Lists

Update any list page (e.g., blogs page):

```dart
Widget build(BuildContext context) {
  return RefreshIndicator(
    onRefresh: () async {
      await ref.read(blogDataProvider).fetchAllBlogs(refresh: true);
    },
    child: ListView.builder(
      // ... your list ...
    ),
  );
}
```

---

## 📝 Implementation Checklist

### Phase 1: Core Services (Day 1)
- [ ] Create `api_service.dart` with standardized methods
- [ ] Create `cache_service.dart` for caching
- [ ] Create `loading_service.dart` for loading indicators
- [ ] Add `shared_preferences` to `pubspec.yaml`
- [ ] Add `flutter_spinkit` to `pubspec.yaml`

### Phase 2: API Updates (Day 2-3)
- [ ] Update `blogapi.dart` to use ApiService
- [ ] Update `user.dart` to use ApiService
- [ ] Update `categoryapi.dart` to use ApiService
- [ ] Update `favrtapi.dart` to use ApiService
- [ ] Update `listingapi.dart` to use ApiService
- [ ] Update `rent_in_api.dart` to use ApiService
- [ ] Update `rent_out_api.dart` to use ApiService
- [ ] Update `messegeapi.dart` to use ApiService

### Phase 3: UI Enhancements (Day 4)
- [ ] Add RefreshIndicator to all list pages
- [ ] Add loading overlays to heavy operations
- [ ] Add retry buttons on error states
- [ ] Implement pull-to-refresh

### Phase 4: Testing (Day 5)
- [ ] Test all APIs with real data
- [ ] Test offline behavior
- [ ] Test caching
- [ ] Test error handling
- [ ] Test retry logic

---

## 🎯 Quick Wins (Apply Now!)

### 1. Add Timeout to All Requests

Find and replace in all API files:
```dart
// OLD:
final response = await http.get(Uri.parse(url));

// NEW:
final response = await http.get(Uri.parse(url))
    .timeout(Duration(seconds: 30));
```

### 2. Standardize Error Messages

Replace all error handling:
```dart
// OLD:
if (response.statusCode == 200) {
  // success
} else {
  debugPrint('Error');
}

// NEW:
if (response.statusCode == 200) {
  // success
} else {
  final data = jsonDecode(response.body);
  showErrorToast(data['msg'] ?? 'Operation failed');
  debugPrint('API Error ${response.statusCode}: ${data['msg']}');
}
```

### 3. Add Debug Logging

Add before every API call:
```dart
debugPrint('📤 API Call: $endpoint');
debugPrint('📦 Params: $params');

// ... make request ...

debugPrint('📥 Response ${response.statusCode}');
debugPrint('📄 Body: ${response.body}');
```

---

## ✅ Summary

By implementing these improvements, your app will have:
- ✅ **Better error handling** - Users see helpful messages
- ✅ **Faster performance** - Caching reduces API calls
- ✅ **Better UX** - Loading indicators and pull-to-refresh
- ✅ **More reliable** - Retry logic handles temporary failures
- ✅ **Easier maintenance** - Centralized API service

Start with Phase 1 services, then gradually update each API file. The app will become much smoother!
