class AppConfig {
  // App Information
  static const String appName = 'SwipeNews';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Your daily news, one swipe at a time';

  // Colors
  static const int primaryColorValue = 0xFF2196F3; // Blue
  static const int accentColorValue = 0xFFFF9800; // Orange

  // Animation Durations
  static const Duration splashAnimationDuration = Duration(milliseconds: 1000);
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);
  static const Duration cardAnimationDuration = Duration(milliseconds: 300);

  // Storage Keys
  static const String likedNewsKey = 'liked_news';
  static const String dislikedNewsKey = 'disliked_news';
  static const String neutralNewsKey = 'neutral_news';

  // UI Constants
  static const double cardBorderRadius = 20.0;
  static const double buttonBorderRadius = 25.0;
  static const double headerHeight = 80.0;
  static const double cardMargin = 16.0;

  // News Card Settings
  static const int maxTitleLines = 3;
  static const int maxDescriptionLines = 4;
  static const double imageHeight = 250.0;

  // Swipe Thresholds
  static const double swipeThreshold = 100.0;
  static const double maxSwipeAngle = 30.0;

  // Error Messages
  static const String networkErrorMessage = 'Network error occurred';
  static const String loadingErrorMessage = 'Failed to load news';
  static const String noNewsMessage = 'No news available';

  // Success Messages
  static const String likeSuccessMessage = 'Article liked successfully';
  static const String dislikeSuccessMessage = 'Article disliked successfully';
  static const String neutralSuccessMessage = 'Article marked as neutral';
}
