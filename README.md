# The Local Rent - Flutter App

A modern, high-performance rental marketplace application built with Flutter.

## 🚀 Features

- ⚡ **Lightning Fast** - Instant data loading with smart caching
- 📱 **Offline Support** - Works seamlessly without internet
- 🏠 **Customizable Home** - Personalize your menu items
- 🔐 **Secure Auth** - User authentication and profiles
- 💬 **Real-time Chat** - Message other users
- 📝 **Blogs** - Read and share rental tips
- ⭐ **Favorites** - Save your favorite items
- 🔔 **Notifications** - Stay updated on activities

## 📊 Performance

- **Load Time**: 0ms (instant with cache)
- **Offline**: 100% functional
- **API Coverage**: 11/11 cached
- **Cache Strategy**: Smart background refresh

## 📚 Documentation

Find detailed documentation in the `docs/` folder:

- [Cache Implementation](docs/ALL_APIS_CACHED_FINAL.md) - Complete guide to the caching system
- [Customizable Home Menu](docs/CUSTOMIZABLE_HOME_MENU.md) - Home menu customization feature
- [Null Safety Guide](docs/NULL_SAFETY_README.md) - Null safety implementation reference

## 🛠️ Tech Stack

- **Framework**: Flutter
- **State Management**: Riverpod + ChangeNotifier
- **Local Storage**: Hive
- **HTTP Client**: http package
- **Animations**: flutter_animate
- **Date Picker**: calendar_date_picker2

## 🏗️ Project Structure

```
rent-app/
├── lib/
│   ├── apidata/          # API providers and services
│   ├── constants/        # App constants and config
│   ├── design/           # UI screens and pages
│   ├── helpers/          # Helper functions and utils
│   ├── models/           # Data models
│   ├── providers/        # State providers
│   ├── services/         # Core services (cache, etc)
│   └── widgets/          # Reusable widgets
├── assets/               # Images, fonts, etc
├── docs/                 # Documentation
└── scripts/              # Utility scripts
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Installation

1. Clone the repository
```bash
git clone <repository-url>
cd rent-app
```

2. Install dependencies
```bash
flutter pub get
```

3. Run the app
```bash
flutter run
```

## 🔧 Configuration

Update API endpoints in:
```
lib/constants/api_endpoints.dart
```

## 📱 Build

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## ✨ Key Features Implementation

### Instant Loading (Cache-First Strategy)
All GET APIs use cache-first strategy:
- Data loads instantly from cache (0ms)
- Fresh data fetches in background
- Auto-updates UI when fresh data arrives

### Customizable Home Menu
Users can:
- Add/remove menu items
- Reorder items via drag-and-drop
- Reset to defaults
- Changes persist locally

### Offline Support
- All cached data available offline
- Full app functionality without internet
- Smart sync when connection returns

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is proprietary software.

## 📧 Contact

For support or inquiries, please contact the development team.

---

**Built with ❤️ using Flutter**
