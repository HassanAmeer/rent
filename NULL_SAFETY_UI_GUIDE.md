# Flutter UI Null Safety Quick Reference

## Common Patterns for Displaying Nullable Data

### 🎯 Text Widgets

```dart
// ✅ GOOD: Using demo text extension
Text((data.title ?? '').toNullStringOrDemo('No Title Available'))

// ✅ GOOD: Using model's safe getter
Text(item.displayTitle)  // Model has: String get displayTitle => title.isNotEmpty ? title : 'No Title';

// ✅ GOOD: Direct demo extension
Text(user.name.toNullStringOrDemo('Guest User'))

// ❌ BAD: Might show "null" text or crash
Text(data.title)
Text(data.title ?? null)
```

### 💰 Currency/Numbers

```dart
// ✅ GOOD: Safe price display
Text('\$${item.dailyRate.toNullDoubleOrDemo(0.0).toStringAsFixed(2)}')

// ✅ GOOD: Using model's formatted getter
Text(item.formattedDailyRate)  // Model has getter

// ✅ GOOD: With fallback
Text('\$${(price ?? 0.0).toStringAsFixed(2)}')

// ❌ BAD: Might crash on null
Text('\$$price')
```

### 🖼️ Images

```dart
// ✅ GOOD: Using CacheImageWidget with fallback
CacheImageWidget(
  url: blog.image ?? ImgLinks.noItem,
  fit: BoxFit.cover,
)

// ✅ GOOD: Using model's safe getter
CacheImageWidget(
  url: user.fullImageUrl.isNotEmpty ? user.fullImageUrl : ImgLinks.profileImage,
)

// ✅ GOOD: Conditional rendering
if (item.hasImages)
  Image.network(item.firstImage)
else
  Image.asset(ImgLinks.noItem)
```

### 📅 Dates

```dart
// ✅ GOOD: Using enhanced extension
Text(notification.createdAt.toReadableStringOrDemo('Just now'))

// ✅ GOOD: Using model's formatted getter  
Text(notification.formattedCreatedDate)

// ✅ GOOD: With null check
Text(item.createdAt?.toReadableString() ?? 'Date not available')

// ❌ BAD: Might crash
Text(DateFormat('MMM dd').format(createdAt))
```

### 📝 Lists and Collections

```dart
// ✅ GOOD: Safe list access
if (items.isNotEmpty) {
  ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, index) => ItemCard(item: items[index]),
  )
} else {
  Center(child: Text('No items available'))
}

// ✅ GOOD: Using default value
final tags = blog.tags.isNotEmpty ? blog.tags : ['General'];

// ✅ GOOD: Safe first accessor
final firstImage = images.isNotEmpty ? images.first : ImgLinks.noItem;
```

### 🔗 Navigation with Data

```dart
// ✅ GOOD: Check before navigation
onTap: item.id > 0 ? () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ItemDetails(item: item),
    ),
  );
} : null,

// ✅ GOOD: With validation
onPressed: () {
  if (user.email.isNotEmpty) {
    Navigator.pushNamed(context, '/profile', arguments: user);
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('User data not available')),
    );
  }
}
```

### 🎨 Conditional Rendering

```dart
// ✅ GOOD: Using ternary operator
Container(
  color: isActive ? Colors.green : Colors.grey,
  child: Text(status.toNullStringOrDemo('Inactive')),
)

// ✅ GOOD: Using if-else
if (user.hasCompleteProfile)
  CompleteProfileWidget(user: user)
else
  IncompleteProfileWidget(),

// ✅ GOOD: Null-aware cascade
userData
  ?..name = 'New Name'
  ?..email = 'new@email.com'
```

## 🎯 Page-Specific Examples

### Blog Details Page
```dart
// Title
Text(blog.title.toNullStringOrDemo('Untitled Blog'))

// Content  
HtmlWidget(blog.content.toNullStringOrDemo('No content available'))

// Author
Text('By ${blog.author.toNullStringOrDemo('Unknown Author')}')

// Published Date
Text(blog.publishedAt.toReadableStringOrDemo('Not published yet'))

// Tags
Wrap(
  children: blog.tags.isNotEmpty
    ? blog.tags.map((tag) => Chip(label: Text(tag))).toList()
    : [Chip(label: Text('General'))],
)
```

### Item Details Page
```dart
// Title
Text(item.title.toNullStringOrDemo('Demo Item'))

// Price
Text(item.formattedDailyRate)  // Uses model getter

// Description
Text(item.shortDescription)  // Uses model getter with fallback

// Owner Info
Text(item.userDisplayName)  // Uses model getter
CacheImageWidget(url: item.userImageUrl)  // Uses model getter

// Availability
if (item.isAvailable)
  Text('Available')
else
  Text('Not available')
```

### User Profile Page
```dart
// Name
Text(user.displayName)  // Uses getter with email fallback

// Email
Text(user.email.toNullStringOrDemo('No email provided'))

// Phone (nullable field)
if (user.phone != null && user.phone!.isNotEmpty)
  Text(user.phone!)
else
  Text('+1 234 567 8900')  // Demo phone

// Address (nullable field)
Text(user.address ?? 'No address provided')

// Profile Image
CacheImageWidget(
  url: user.fullImageUrl.isNotEmpty ? user.fullImageUrl : ImgLinks.profileImage,
  isCircle: true,
)

// Profile Completeness
LinearProgressIndicator(
  value: user.hasCompleteProfile ? 1.0 : 0.5,
)
```

### Notification Page
```dart
// Title
Text(notification.displayTitle)  // Uses model getter

// Description  
Text(notification.shortDescription)  // Uses model getter with HTML cleanup

// Time
Text(notification.formattedCreatedDate)  // Uses relative time

// Badge for recent
if (notification.isRecent)
  Badge(label: Text('New'))

// Sender
if (notification.fromUser != null)
  Text('From: ${notification.fromUser!.displayName}')
else
  Text('From: System')
```

## 🚨 Common Mistakes to Avoid

### ❌ Don't Do This:
```dart
// Calling toString() on potentially null
Text(user.name.toString())  // Shows "null" if name is null

// Force unwrapping without checking
Text(data!.title)  // Crashes if data is null

// Using empty string as meaningful data
if (title == '') { }  // Use: if (title.isEmpty) { }

// Ignoring model getters
Text(item.title ?? 'No Title')  // Use: Text(item.displayTitle)
```

### ✅ Do This Instead:
```dart
// Use demo extensions
Text((user.name ?? '').toNullStringOrDemo('Guest'))

// Use null-aware operators
Text(data?.title ?? 'No Title')

// Use isEmpty check
if (title.isEmpty) { }

// Use model's safe getters
Text(item.displayTitle)
```

## 📋 Checklist for Each Page

- [ ] All Text widgets have fallback values
- [ ] All Image widgets use safe accessors or default images
- [ ] All navigation passes valid/checked data
- [ ] All lists check for empty state
- [ ] All dates use safe formatters
- [ ] All numbers/prices have fallback values
- [ ] All nullable Model fields are properly checked before use
- [ ] Loading states are implemented
- [ ] Error states are handled

## 🎨 Demo Data Best Practices

1. **Be Descriptive**: "Demo Product" not "test"
2. **Be Realistic**: "$25.00" not "$999999"
3. **Match Format**: "demo@example.com" not "test"
4. **Be Helpful**: "Loading data..." for temporary states
5. **Be Consistent**: Use same demo format across app

---
**Remember**: Always prefer using Model getters over inline null checks in UI code!
