# 👓 KacamataMoo

**Eyewear for Everyone** - Discover Your Perfect Glasses with AI-Powered Virtual Try-On

KacamataMoo is a cutting-edge mobile application that revolutionizes the eyewear shopping experience through augmented reality (AR) virtual try-on technology, personalized frame recommendations, and AI-powered facial analysis.

## ✨ Features

### 🎯 Core Functionality
- **AR Virtual Try-On**: Real-time 3D glasses rendering on your face using ARCore
- **AI Frame Recommendations**: Intelligent questionnaire-based suggestions for frames and lenses
- **Face Shape Analysis**: ML-powered facial feature detection for personalized recommendations
- **Multi-language Support**: Available in Indonesian (ID) and English (EN)
- **Privacy-First**: No facial recognition storage, all processing done locally

### 📱 User Experience
- **Responsive Design**: Optimized for both mobile and tablet devices
- **Material 3 Theming**: Modern, consistent UI with light/dark mode support
- **Offline Capabilities**: Local data storage with GetStorage
- **Smooth Animations**: Lottie animations for engaging user experience

## 🏗️ Architecture

KacamataMoo uses **Clean Architecture** with **GetX** for state management, following a clear separation of concerns across presentation, domain, and data layers.

### Project Structure
```
lib/
├── app/                      # App configuration & routing
│   └── routes/               # Navigation routes
├── core/                     # Core utilities & constants
│   ├── base/                 # Base classes & utilities
│   ├── constants/            # Colors, assets, strings
│   ├── network/              # API & networking layer
│   └── utils/                # Helper functions
├── data/                     # Data layer
│   ├── models/               # Data models
│   └── repositories/         # Data repositories
├── localization/             # i18n translations
└── presentation/             # UI layer
    ├── theme/                # App themes & styling
    ├── views/                # Screens & widgets
    │   ├── screens/          # App screens
    │   └── widgets/          # Reusable widgets
    └── controllers/          # GetX controllers
```

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK**: `>=3.10.4 <4.0.0`
- **Dart SDK**: Latest stable version
- **Android Studio** / **VS Code** with Flutter extensions
- **Android SDK**: API Level 24+ (Android 7.0+)
- **ARCore**: Device must support ARCore

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd kmm-frame-mobile
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Setup environment variables**
   - Copy `.env.example` to `.env` (if exists)
   - Configure API endpoints and keys

4. **Run the app**
   ```bash
   flutter run
   ```

### Build for Production

**Android APK:**
```bash
flutter build apk --release
```

**Android App Bundle:**
```bash
flutter build appbundle --release
```

## 🎨 Theming System

KacamataMoo uses a comprehensive Material 3 theme system. See [THEME_GUIDE.md](THEME_GUIDE.md) for detailed documentation.

### Quick Theme Usage
```dart
// Access theme colors
final theme = Theme.of(context);
Container(
  color: theme.colorScheme.primary,
  child: Text(
    'Hello',
    style: theme.textTheme.headlineMedium,
  ),
)
```

### Color Palette
- **Primary (Teal)**: `#44A8A9` - Main brand color
- **Secondary (Navy)**: `#141C48` - Supporting color
- **Tertiary (Yellow)**: `#FFDE59` - Accent color
- **Background**: `#F3F4F8` - Light mode background

## 📦 Key Dependencies

### Core
- **GetX** (`^4.7.3`): State management, routing, dependency injection
- **GetStorage** (`^2.1.1`): Local data persistence

### Networking
- **Dio** (`^5.9.0`): HTTP client for API calls
- **Connectivity Plus** (`^7.0.0`): Network connectivity monitoring

### AR & ML
- **DeepAR Flutter**: AR face filters and virtual try-on
- **Google ML Kit**: Face detection and analysis
- **Face Camera**: Camera integration for face tracking

### UI/UX
- **Lottie** (`^3.3.0`): Animation support
- **Cached Network Image** (`^3.4.1`): Optimized image loading
- **QR Flutter** (`^4.1.0`): QR code generation/scanning

## 🌐 Localization

The app supports multiple languages using GetX translations:

```dart
// In code
Text('welcome_message'.tr)

// Add new translations in:
lib/localization/
├── en_US.dart   # English
└── id_ID.dart   # Indonesian
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## 📱 Supported Platforms

- ✅ **Android**: API 24+ (Android 7.0+)
- 🚧 **iOS**: Planned support
- ❌ **Web**: Not planned (requires AR capabilities)
- ❌ **Desktop**: Not planned

## 🔒 Privacy & Security

- ✅ No facial recognition data stored
- ✅ All AR processing done locally on device
- ✅ GDPR-compliant data handling
- ✅ Privacy policy integration
- ✅ Transparent permission requests

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is proprietary software. All rights reserved.

## 📞 Contact & Support

For questions, issues, or support:
- **Email**: support@kacamatamoo.com
- **Documentation**: See [docs/](docs/) folder
- **Theme Guide**: [THEME_GUIDE.md](THEME_GUIDE.md)

## 📋 Changelog

### [1.0.1] - 2026-01-28

#### Added
- 🖼️ New background image for application (`background_app.jpg`)
- 💾 Enhanced cache management with new `CacheManager` utility class
- 🔐 Improved login screen controller with additional functionality

#### Changed
- 🎨 Redesigned login screen UI with improved user experience
- 🚀 Updated splash screen implementation
- 📝 Refined heading card widget design
- ⚙️ Updated app environment configuration

#### Removed
- 🗑️ Removed Linux platform support (CMakeLists, build files, runner)
- 🗑️ Removed macOS platform support (Xcode project, Runner, entitlements)
- 🗑️ Removed Windows platform support (CMakeLists, runner, resources)
- 📦 Cleaned up `.env` file from repository (now gitignored)

#### Technical
- 🔧 Updated dependency versions in `pubspec.yaml`
- 🔒 Enhanced `.gitignore` to include `.env` file
- 🏗️ Focused development on Android platform only
- 📉 Reduced codebase size by ~3,000 lines through platform cleanup

---

### [1.0.0] - 2026-01-27

#### Added
- ✨ AR support detection functionality in `GlobalFunctionHelper`
- 🎯 AR compatibility check before face scanning starts
- 🔘 Next button on face scanning screen with progress-based enablement
- 📊 Enhanced scan result display with organized frame and color recommendations
- 🎨 Wrap layout for frame types and colors (horizontal flow with automatic wrapping)
- 🏷️ Styled chip badges for frame recommendations (blue) and color recommendations (green)
- 📦 Proper data model structure for `ScanResultModel` with nested models
- 🔧 Helper methods in `ScanResultController` for getting sorted recommendations

#### Fixed
- 🐛 Fixed type mismatch error when passing ML result data from arguments
- 🔄 Updated `ScanResultModel` to use proper JSON serialization
- 📏 Corrected measurement data access through `measurements` property
- 🎯 Fixed perfect match display to show top-scored recommendations

#### Changed
- 🔄 Moved AR support checking from controller to `GlobalFunctionHelper` for reusability
- 📱 Updated scan result screen to display recommendations as interactive chips
- 🎨 Changed recommendation display from single values to sortable lists
- 💾 Improved data model format for better JSON handling

#### Technical
- 📚 Added `device_info_plus` integration for AR capability detection
- 🏗️ Refactored data model structure for scan results
- 🔧 Enhanced controller methods for recommendation sorting and formatting
- 🎯 Integrated AR check into face scanning initialization flow

---

### Future Planned Features
- 🌟 iOS AR support implementation
- 🔄 Real-time AR frame switching
- 📸 Save and share virtual try-on photos
- 🛒 Direct purchase integration
- 👥 Social media sharing features

## �🙏 Acknowledgments

- **DeepAR SDK** - AR technology
- **Google ARCore** - Augmented reality platform
- **Flutter Team** - Amazing framework
- **GetX Community** - State management ecosystem

---

**Made with ❤️ for eyewear enthusiasts everywhere**
