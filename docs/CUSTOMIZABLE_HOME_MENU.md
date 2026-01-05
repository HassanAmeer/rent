# 🎨 Customizable Home Menu - Feature Documentation

## ✨ What Was Created

You can now **customize the home page menu** in your Flutter app! Users can add, remove, reorder, and choose from all available options.

---

## 🎯 Features

### 1. **Editable Menu Items** ✅
- Users can add/remove menu items from home page
- Drag-and-drop reordering
- Choose from 11 available options
- Changes persist across app restarts

### 2. **Available Menu Options**:
1. ✅ My Favorites
2. ✅ Rent Outs
3. ✅ Rent In 
4. ✅ My Listings
5. ✅ All Items
6. ✅ Blogs
7. ✅ Messages
8. ✅ Notifications
9. ✅ Help &  Support
10. ✅ Settings
11. ✅ My Profile

### 3. **Default Configuration**:
- My Favorites
- Rent Outs
- Blogs
- Help & Support

---

## 📂 Files Created

### Models
```
lib/models/home_menu_item.dart
```
- `HomeMenuItem` class with serialization
- `AvailableMenuOptions` static list

### Providers
```
lib/providers/home_menu_provider.dart
```
- `HomeMenuManager` with Hive storage
- Add/remove/reorder functionality
- Persistent storage

### UI Pages
```
lib/design/settings/customize_home_menu_page.dart
```
- Visual customization interface
- Drag-drop reordering
- Grid of available options
- Reset to default button

### Helpers
```
lib/helpers/route_helper.dart
```
- Maps route names to actual page widgets

---

## 📱 How to Use

### For Users:

1. **Open App** → Home page loads with default menu

2. **Customize Menu**:
   - Tap "Customize" button on home page (next to "Quick Access")
   - See current menu items (top section)
   - See available options (bottom grid)

3. **Add Items**:
   - Tap any item in the "Available Options" grid
   - It appears immediately in your menu

4. **Remove Items**:
   - Tap the red delete icon on any current menu item

5. **Reorder Items**:
   - Long-press and drag items to reorder
   - New order saves automatically

6. **Reset**:
   - Tap refresh icon in app bar
   - Confirms and resets to defaults

### For Developers:

#### Initialize on Home Page:
```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    // ... other init code ...
    
    // ✅ Initialize home menu
    await ref.read(homeMenuProvider).init();
  });
}
```

#### Display Dynamic Menu:
```dart
ListView.builder(
  scrollDirection: Axis.horizontal,
  itemCount: ref.watch(homeMenuProvider).menuItems.length,
  itemBuilder: (context, index) {
    final menuItem = ref.watch(homeMenuProvider).menuItems[index];
    final page = RouteHelper.getPageFromRoute(menuItem.routeName);
    
    return homeMenuBoxWidget(
      label: menuItem.label,
      pageName: page,
      icon: menuItem.icon,
    );
  },
)
```

---

## 🎨 UI/UX Features

### Customization Page:

**Top Section** - Current Menu Items
- Shows all active menu items
- Drag handle for reordering
- Delete button for each item
- Order number displayed

**Bottom Section** - Available Options  
- 3-column grid layout
- Icons with labels
- Add (+) icon indicator
- Smooth animations

**Empty States**:
- "No menu items" when list is empty
- "All items added!" when all options used
- Helpful messages and action buttons

### Animations:
- ✨ Fade-in when items appear
- ✨ Scale animation on available items
- ✨ Smooth transitions

---

## 💾 Storage

Data is saved locally using **Hive**:

```dart
// Storage location
Box: 'homeMenuBox'
Key: 'menuItems'

// Data format
[
  {
    'id': 'favorites',
    'label': 'My Favorites',
    'iconCodePoint': 58910,
    'iconFontFamily': 'Material Icons',
    'routeName': 'favorites',
    'order': 0
  },
  // ... more items
]
```

**Persistence**: Menu customization survives:
- App restarts
- Device reboots
- App updates (unless storage is cleared)

---

## 🔧 How It Works

### Architecture:

```
HomeMenuItem Model (data class)
     ↓
HomeMenuManager (provider with Hive)
     ↓
HomePage (displays dynamic menu)
     ↕
CustomizeHomeMenuPage (edit interface)
```

### Flow:

1. **App  Launch**:
   - `Home MenuManager.init()` called
   - Checks Hive for saved data
   - Loads saved or default items

2. **Display**:
   - HomePage watches `homeMenuProvider`
   - Builds menu from current items
   - Uses `RouteHelper` for navigation

3. **Customization**:
   - User taps "Customize"
   - Opens `CustomizeHomeMenuPage`
   - Changes update provider
   - Provider saves to Hive
   - HomePage auto-updates (Riverpod)

---

## 🎯 Code Examples

### Add Custom Menu Item Programmatically:
```dart
await ref.read(homeMenuProvider).addMenuItem('messages');
```

### Remove Item:
```dart
await ref.read(homeMenuProvider).removeMenuItem('help');
```

### Reorder:
```dart
await ref.read(homeMenuProvider).reorderItems(oldIndex: 0, newIndex: 2);
```

### Reset to Default:
```dart
await ref.read(homeMenuProvider).resetToDefault();
```

### Check Available Items:
```dart
final available = ref.read(homeMenuProvider).getAvailableItems();
print('${available.length} items available to add');
```

---

## 🚀 Future Enhancements (Optional)

### Possible Additions:
1. **Custom Icons** - Let users choose custom icons
2. **Custom Labels** - Rename menu items
3. **Color Themes** - Different colors per item
4. **Import/Export** - Share configurations
5. **Profiles** - Multiple menu layouts
6. **More Options** - Add categories, search, etc.

---

## ✅ Testing Checklist

- [x] Menu items load from storage
- [x] Default items set on first launch
- [x] Add items works
- [x] Remove items works
- [x] Reorder works (drag-drop)
- [x] Reset to default works
- [x] Navigation to pages works
- [x] Changes persist after app restart
- [x] Empty states display correctly
- [x] Animations work smoothly

---

## 🎨 Customization Tips

### For Better UX:
1. Keep 3-5 menu items (not too many)
2. Most used items first
3. Balance visual spacing
4. Test on different screen sizes

### Design Consistency:
- All menu icons from Material Icons
- Consistent sizing (iconSize: 50)
- White backgrounds with shadows
- Cyan accent color

---

## 📊 Performance

- ✅ **Fast**: Menu loads instantly from Hive
- ✅ **Efficient**: Only loads when needed
- ✅ **Smooth**: Riverpod for reactive updates
- ✅ **Small**: <1KB storage per configuration

---

## 🎉  Summary

You now have a **fully customizable home menu**! Users can:

✅ Choose which menu items to show  
✅ Reorder items by dragging  
✅ Add new items from available options  
✅ Remove items they don't use  
✅ Reset to defaults anytime  

All changes **save automatically** and **persist across app restarts**!

The home page now has a "**Customize**" button (top right of Quick Access section) that opens the customization interface.

**Default menu** includes:
1. My Favorites
2. Rent Outs
3. Blogs
4. Help & Support

Users can add **7 more options** from the available menu!

---

**Created**: January 5, 2026  
**Status**: ✅ Complete & Working  
**Type**: User Customization Feature
