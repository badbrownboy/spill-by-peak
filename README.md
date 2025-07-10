# 🗣️ Spill by PEAK - Social Connection App

**Spill** is a modern Flutter social networking app that connects people through rich profiles, real-time chat, and intuitive search features. Built with a focus on authentic connections and user expression.

## ✨ Features

### 🔐 **Authentication System**
- Beautiful animated splash screen
- Sign up with email/phone/username
- Login with persistent sessions
- Password reset functionality
- Apple Sign-In integration (coming soon)

### 👤 **Rich User Profiles**
- **7-Step Onboarding Flow** for new users:
  1. Name & Gender selection
  2. Age verification (18+)
  3. Location & Height
  4. Ethnicity selection
  5. Social media handles (Instagram, TikTok, Snapchat)
  6. Personal bio (150 characters)
  7. Profile media (photo or video)

### 💬 **Real-time Chat**
- Modern chat interface
- Message history
- User status indicators
- Smart loading states

### 🔍 **Smart Search**
- Find users by name, location, interests
- Filter by age, location, ethnicity
- Profile preview cards
- Advanced search options

### 🎨 **Modern UI/UX**
- Dark theme design
- Smooth animations
- Custom loading widgets (spinning flag animation)
- Network connectivity detection
- Responsive design

## 🛠️ Tech Stack

- **Framework**: Flutter 3.x
- **Language**: Dart
- **Database**: SQLite (local storage with sqflite)
- **State Management**: Built-in StatefulWidget
- **Image Handling**: image_picker
- **Network**: http, connectivity_plus
- **Storage**: shared_preferences
- **Navigation**: MaterialPageRoute

## 📱 Platforms

- ✅ iOS
- ✅ Android
- ✅ Web
- ✅ macOS
- ✅ Windows
- ✅ Linux

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.0+
- Dart 3.0+
- iOS 11.0+ / Android API 21+

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/badbrownboy/spill-by-peak.git
   cd spill-by-peak
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Build for Release

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  sqflite: ^2.3.3+1
  path: ^1.9.0
  shared_preferences: ^2.2.3
  http: ^1.2.1
  image_picker: ^1.1.1
  connectivity_plus: ^6.0.3
```

## 🏗️ Project Structure

```
lib/
├── main.dart                    # App entry point
├── models/
│   └── user_model.dart         # User data model
├── services/
│   ├── user_service.dart       # User authentication & management
│   └── network_service.dart    # Network connectivity
├── database/
│   └── database_helper.dart    # SQLite database operations
├── screens/
│   ├── main_navigation_screen.dart      # Bottom navigation
│   ├── enhanced_sign_up_page.dart       # Sign up flow
│   ├── profile_onboarding_screen.dart   # 7-step onboarding
│   ├── profile_page.dart               # User profile
│   ├── search_page.dart                # Search & discovery
│   └── chat_page.dart                  # Messaging
└── widgets/
    ├── custom_loading_widget.dart      # Animated loading spinner
    └── smart_loading_widget.dart       # Network-aware loading
```

## 🎯 Features Roadmap

- [ ] **Push Notifications** - Real-time message notifications
- [ ] **Video Profiles** - Enhanced video profile support
- [ ] **Group Chats** - Multi-user conversations
- [ ] **Stories** - Temporary content sharing
- [ ] **Location Services** - Nearby users discovery
- [ ] **Dark/Light Theme** - Theme customization
- [ ] **Advanced Filters** - Enhanced search capabilities
- [ ] **Media Sharing** - Photos/videos in chat
- [ ] **Voice Messages** - Audio communication
- [ ] **Privacy Controls** - Advanced privacy settings

## 📸 Screenshots

*Coming Soon - Add screenshots of your app here*

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**PEAK Development Team**
- 📧 Email: contact@peak-dev.com
- 🐦 Twitter: [@peak_dev](https://twitter.com/peak_dev)
- 🌐 Website: [peak-development.com](https://peak-development.com)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- The open-source community for inspiration
- All contributors and testers

---

**Built with ❤️ using Flutter**
