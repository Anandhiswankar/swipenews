# SwipeNews - News App with Vertical Swipe Functionality

A modern news application built with Flutter that provides a YouTube Shorts/Instagram Reels-like experience with vertical swipe navigation, like/dislike functionality, and beautiful UI design.

## Features

### 🎯 Core Functionality
- **Vertical Swipe Navigation**: Swipe up for next news, down for previous (like YouTube Shorts & Instagram Reels)
- **Full-Screen News Cards**: Beautiful full-screen cards with background images and overlay text
- **Like/Dislike/Neutral**: Rate news articles and store preferences locally
- **External Browser**: Opens news URLs in default browser
- **Local Storage**: All user preferences are stored locally on the device

### 🎨 User Interface
- **Modern Design**: Clean, full-screen UI with smooth animations
- **Responsive Layout**: Works seamlessly on Android, iOS, Windows, and Web
- **Smooth Transitions**: Fade, scale, and transition animations
- **Navigation Controls**: Manual buttons for easy browsing
- **Dark Theme**: Optimized for content consumption with dark backgrounds

### 📱 Cross-Platform Support
- ✅ Android
- ✅ iOS  
- ✅ Windows
- ✅ Web
- ✅ macOS
- ✅ Linux

## Screenshots

The app features:
- **Splash Screen**: Beautiful animated logo and app name
- **News Swiper**: Main screen with swipeable news cards
- **Web View**: Opens news URLs in external browser
- **Local Storage**: Remembers your likes, dislikes, and neutral ratings

## Getting Started

### Prerequisites
- Flutter SDK (3.7.2 or higher)
- Dart SDK
- Android Studio / VS Code
- Android Emulator / iOS Simulator / Physical Device

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd swipenews
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Building for Different Platforms

#### Android
```bash
flutter build apk
```

#### iOS
```bash
flutter build ios
```

#### Web
```bash
flutter build web
```

#### Windows
```bash
flutter build windows
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── config/
│   └── app_config.dart      # App configuration
├── models/
│   └── news_model.dart      # News data models
├── screens/
│   ├── splash_screen.dart   # Splash screen
│   ├── news_swiper_screen.dart  # Main news swiper
│   └── web_view_screen.dart # Web view for URLs
├── services/
│   ├── news_service.dart    # News data loading
│   └── storage_service.dart # Local storage management
└── widgets/
    └── news_card.dart       # News card widget
```

## Dependencies

The app uses the following key packages:
- `flutter_card_swiper`: For swipe functionality
- `shared_preferences`: For local data storage
- `url_launcher`: For opening external URLs
- `cached_network_image`: For efficient image loading
- `intl`: For date formatting
- `flutter_staggered_animations`: For smooth animations

## How It Works

1. **Data Loading**: News articles are loaded from the local JSON file (`asset/json/news.json`)
2. **Swipe Navigation**: Users can swipe between news articles using touch gestures
3. **User Preferences**: Like, dislike, and neutral ratings are stored locally using SharedPreferences
4. **External Links**: Tapping on news cards opens the full article in the default browser
5. **Local Storage**: All user interactions are persisted locally for future reference

## Swipe Gestures

- **Swipe Up**: Navigate to the next news article
- **Swipe Down**: Navigate to the previous news article
- **Tap**: Open the full article in external browser
- **Like/Dislike/Neutral**: Rate articles with animated buttons

## Customization

### Adding New News Sources
1. Update the `asset/json/news.json` file with new articles
2. Follow the existing JSON structure
3. Ensure all required fields are present

### Modifying UI Theme
1. Update colors in `lib/main.dart`
2. Modify card styles in `lib/widgets/news_card.dart`
3. Adjust animations in `lib/screens/splash_screen.dart`

### Changing Storage Logic
1. Modify `lib/services/storage_service.dart`
2. Add new preference types as needed
3. Update the UI to reflect new storage options

## Troubleshooting

### Common Issues

1. **Dependencies not found**
   ```bash
   flutter clean
   flutter pub get
   ```

2. **Build errors on specific platforms**
   - Ensure platform-specific dependencies are installed
   - Check Flutter doctor for platform-specific issues

3. **Images not loading**
   - Verify internet connection
   - Check image URLs in the JSON file
   - Ensure proper permissions on Android/iOS

### Performance Tips

- The app uses cached network images for better performance
- Local storage operations are asynchronous to prevent UI blocking
- Smooth animations are optimized for 60fps performance
- Full-screen cards provide immersive reading experience

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test on multiple platforms
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Create an issue in the repository
- Check the Flutter documentation
- Review the code comments for implementation details

Developed By Anand Hiswankar
---

**Built with ❤️ using Flutter**
