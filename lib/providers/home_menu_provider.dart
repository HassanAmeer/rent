import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rent/models/home_menu_item.dart';

/// Provider for home menu items
final homeMenuProvider = ChangeNotifierProvider<HomeMenuManager>(
  (ref) => HomeMenuManager(),
);

class HomeMenuManager with ChangeNotifier {
  List<HomeMenuItem> _menuItems = [];
  bool _isLoading = false;

  List<HomeMenuItem> get menuItems => _menuItems;
  bool get isLoading => _isLoading;

  /// Initialize with default or saved menu items
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Hive.openBox('homeMenuBox');
      final box = Hive.box('homeMenuBox');
      final savedItems = box.get('menuItems');

      if (savedItems != null && savedItems is List) {
        // Load saved items
        _menuItems = savedItems
            .map(
              (item) => HomeMenuItem.fromJson(Map<String, dynamic>.from(item)),
            )
            .toList();

        // Sort by order
        _menuItems.sort((a, b) => a.order.compareTo(b.order));
      } else {
        // Set default menu items (same as old static menu)
        _menuItems = [
          AvailableMenuOptions.getById('favorites')!.copyWith(order: 0),
          AvailableMenuOptions.getById('rent_outs')!.copyWith(order: 1),
          AvailableMenuOptions.getById('blogs')!.copyWith(order: 2),
          AvailableMenuOptions.getById('help')!.copyWith(order: 3),
        ];
        await _saveToStorage();
      }
    } catch (e) {
      debugPrint('Error loading menu items: $e');
      // Fallback to defaults (same as old static menu)
      _menuItems = [
        AvailableMenuOptions.getById('favorites')!.copyWith(order: 0),
        AvailableMenuOptions.getById('rent_outs')!.copyWith(order: 1),
        AvailableMenuOptions.getById('blogs')!.copyWith(order: 2),
        AvailableMenuOptions.getById('help')!.copyWith(order: 3),
      ];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Save menu items to storage
  Future<void> _saveToStorage() async {
    try {
      // Ensure box is opened
      if (!Hive.isBoxOpen('homeMenuBox')) {
        await Hive.openBox('homeMenuBox');
      }

      final box = Hive.box('homeMenuBox');
      final itemsJson = _menuItems.map((item) => item.toJson()).toList();
      await box.put('menuItems', itemsJson);
    } catch (e) {
      debugPrint('Error saving menu items: $e');
    }
  }

  /// Add a new menu item
  Future<void> addMenuItem(String itemId) async {
    final availableItem = AvailableMenuOptions.getById(itemId);
    if (availableItem == null) return;

    // Check if already exists
    if (_menuItems.any((item) => item.id == itemId)) {
      debugPrint('Item already exists');
      return;
    }

    final newItem = availableItem.copyWith(order: _menuItems.length);
    _menuItems.add(newItem);
    await _saveToStorage();
    notifyListeners();
  }

  /// Remove a menu item
  Future<void> removeMenuItem(String itemId) async {
    _menuItems.removeWhere((item) => item.id == itemId);

    // Reorder remaining items
    for (int i = 0; i < _menuItems.length; i++) {
      _menuItems[i] = _menuItems[i].copyWith(order: i);
    }

    await _saveToStorage();
    notifyListeners();
  }

  /// Reorder menu items
  Future<void> reorderItems(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final item = _menuItems.removeAt(oldIndex);
    _menuItems.insert(newIndex, item);

    // Update order values
    for (int i = 0; i < _menuItems.length; i++) {
      _menuItems[i] = _menuItems[i].copyWith(order: i);
    }

    await _saveToStorage();
    notifyListeners();
  }

  /// Reset to default menu items
  Future<void> resetToDefault() async {
    _menuItems = [
      AvailableMenuOptions.getById('favorites')!.copyWith(order: 0),
      AvailableMenuOptions.getById('rent_outs')!.copyWith(order: 1),
      AvailableMenuOptions.getById('blogs')!.copyWith(order: 2),
      AvailableMenuOptions.getById('help')!.copyWith(order: 3),
    ];
    await _saveToStorage();
    notifyListeners();
  }

  /// Get available items (not already added)
  List<HomeMenuItem> getAvailableItems() {
    final addedIds = _menuItems.map((item) => item.id).toSet();
    return AvailableMenuOptions.options
        .where((item) => !addedIds.contains(item.id))
        .toList();
  }
}
