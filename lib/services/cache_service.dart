import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

/// Cache service for storing and retrieving API data locally
///
/// Strategy: Cache-first with background refresh
/// 1. Load from cache immediately (if available)
/// 2. Fetch fresh data from API in background
/// 3. Update UI when fresh data arrives
class CacheService {
  static const String _cacheBoxName = 'api_cache';
  static Box? _cacheBox;

  /// Initialize cache service
  static Future<void> init() async {
    try {
      if (!Hive.isBoxOpen(_cacheBoxName)) {
        _cacheBox = await Hive.openBox(_cacheBoxName);
      } else {
        _cacheBox = Hive.box(_cacheBoxName);
      }
      debugPrint('✅ Cache Service initialized');
    } catch (e) {
      debugPrint('❌ Cache Service init error: $e');
    }
  }

  /// Save data to cache
  static Future<void> saveCache(String key, dynamic data) async {
    try {
      await _ensureBoxOpen();

      final cacheData = {
        'data': data,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      await _cacheBox?.put(key, jsonEncode(cacheData));
      debugPrint('💾 Cached: $key');
    } catch (e) {
      debugPrint('❌ Cache save error for $key: $e');
    }
  }

  /// Get data from cache
  static dynamic getCache(String key) {
    try {
      _ensureBoxOpen();

      final cachedString = _cacheBox?.get(key);
      if (cachedString == null) return null;

      final cacheData = jsonDecode(cachedString);
      debugPrint('📦 Loaded from cache: $key');
      return cacheData['data'];
    } catch (e) {
      debugPrint('❌ Cache read error for $key: $e');
      return null;
    }
  }

  /// Check if cache exists for a key
  static bool hasCache(String key) {
    try {
      _ensureBoxOpen();
      return _cacheBox?.containsKey(key) ?? false;
    } catch (e) {
      return false;
    }
  }

  /// Get cache age in minutes
  static int getCacheAge(String key) {
    try {
      _ensureBoxOpen();

      final cachedString = _cacheBox?.get(key);
      if (cachedString == null) return -1;

      final cacheData = jsonDecode(cachedString);
      final timestamp = cacheData['timestamp'] as int;
      final now = DateTime.now().millisecondsSinceEpoch;

      return ((now - timestamp) / 60000).floor(); // Minutes
    } catch (e) {
      return -1;
    }
  }

  /// Check if cache is stale (older than maxAge in minutes)
  static bool isCacheStale(String key, {int maxAgeMinutes = 30}) {
    final age = getCacheAge(key);
    if (age == -1) return true;
    return age > maxAgeMinutes;
  }

  /// Clear specific cache
  static Future<void> clearCache(String key) async {
    try {
      await _ensureBoxOpen();
      await _cacheBox?.delete(key);
      debugPrint('🗑️ Cleared cache: $key');
    } catch (e) {
      debugPrint('❌ Cache clear error for $key: $e');
    }
  }

  /// Clear all cache
  static Future<void> clearAllCache() async {
    try {
      await _ensureBoxOpen();
      await _cacheBox?.clear();
      debugPrint('🗑️ Cleared all cache');
    } catch (e) {
      debugPrint('❌ Clear all cache error: $e');
    }
  }

  /// Ensure cache box is open
  static Future<void> _ensureBoxOpen() async {
    if (_cacheBox == null || !_cacheBox!.isOpen) {
      await init();
    }
  }

  /// Generate cache key from endpoint and parameters
  static String generateKey(String endpoint, [Map<String, dynamic>? params]) {
    if (params == null || params.isEmpty) {
      return endpoint;
    }

    final sortedParams = params.keys.toList()..sort();
    final paramString = sortedParams
        .map((key) => '$key=${params[key]}')
        .join('&');

    return '${endpoint}_$paramString';
  }
}

/// Extension for easy cache-first API calls
extension CachedApiCall on Future<dynamic> {
  /// Execute with cache-first strategy
  ///
  /// Returns cached data immediately if available,
  /// then fetches fresh data in background and returns it
  Future<dynamic> withCache(String cacheKey) async {
    // Check cache first
    final cachedData = CacheService.getCache(cacheKey);

    // Fetch fresh data
    final freshData = await this;

    // Save to cache
    if (freshData != null) {
      await CacheService.saveCache(cacheKey, freshData);
    }

    return freshData ?? cachedData;
  }
}
