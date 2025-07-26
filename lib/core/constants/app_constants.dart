import 'dart:ui';

class AppConstants {
  // App Information
  static const String appName = 'Sahayak AI';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String baseUrl = 'http://localhost:8000';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Colors (Based on UI Mockup)
  static const Color primaryGreen = Color(0xFF388E3C);
  static const Color lightGreen = Color(0xFFE8F5E9);
  static const Color accentGreen = Color(0xFFB2DFDB);
  static const Color darkGreen = Color(0xFF2E7D32);

  static const Color primaryOrange = Color(0xFFFFA726);
  static const Color lightOrange = Color(0xFFFFF3E0);

  static const Color primaryBlue = Color(0xFF1976D2);
  static const Color lightBlue = Color(0xFFE3F2FD);

  static const Color backgroundGrey = Color(0xFFF5F5F5);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);

  static const Color errorRed = Color(0xFFD32F2F);
  static const Color successGreen = Color(0xFF388E3C);
  static const Color warningAmber = Color(0xFFFFA000);

  // Dimensions
  static const double padding8 = 8.0;
  static const double padding12 = 12.0;
  static const double padding16 = 16.0;
  static const double padding20 = 20.0;
  static const double padding24 = 24.0;
  static const double padding32 = 32.0;

  static const double borderRadius8 = 8.0;
  static const double borderRadius12 = 12.0;
  static const double borderRadius16 = 16.0;
  static const double borderRadius24 = 24.0;
  static const double borderRadius32 = 32.0;

  static const double elevation2 = 2.0;
  static const double elevation4 = 4.0;
  static const double elevation8 = 8.0;

  // Font Sizes
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeRegular = 16.0;
  static const double fontSizeLarge = 18.0;
  static const double fontSizeXLarge = 20.0;
  static const double fontSizeXXLarge = 24.0;
  static const double fontSizeTitle = 28.0;

  // Icon Sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 20.0;
  static const double iconSizeRegular = 24.0;
  static const double iconSizeLarge = 32.0;
  static const double iconSizeXLarge = 48.0;

  // Default Values
  static const String defaultFarmerId = 'farmer_123';
  static const String defaultLocation = 'Karnataka';
  static const String defaultLanguage = 'english';

  // App Strings
  static const Map<String, String> appStrings = {
    'welcome': 'Good morning, user!',
    'askSahayak': 'Ask Sahayak Anything',
    'askSahayakSubtitle': 'Tap the mic to speak in Kannada or English',
    'searchHint': 'Search crops, diseases, schemes…',
    'todayWeather': 'Today\'s Weather',
    'marketSnapshot': 'Market Snapshot',
    'sahayakSays': 'Sahayak Says:',
    'myCrops': 'My Crops',
    'farmOverview': 'Farm Overview',
    'totalInvestment': 'Total Investment',
    'expectedRevenue': 'Expected Revenue',
    'profitMargin': 'Profit Margin',
  };
  // Spacing Constants
  static const double screenPadding = 16.0;
  static const double cardPadding = 20.0;
  static const double smallPadding = 8.0;
  static const double mediumPadding = 12.0;
  static const double largePadding = 24.0;

  // Border Radius Constants
  static const double smallRadius = 8.0;
  static const double mediumRadius = 12.0;
  static const double cardRadius = 16.0;
  static const double largeRadius = 20.0;
  static const double pillRadius = 32.0;

  // Typography Constants
  static const double headlineLarge = 24.0;
  static const double headlineMedium = 20.0;
  static const double headlineSmall = 18.0;
  static const double titleLarge = 16.0;
  static const double titleMedium = 14.0;
  static const double titleSmall = 12.0;
  static const double bodyLarge = 16.0;
  static const double bodyMedium = 14.0;
  static const double bodySmall = 12.0;
  static const double labelLarge = 12.0;
  static const double labelMedium = 11.0;
  static const double labelSmall = 10.0;

  // Icon Sizes
  static const double iconSmall = 16.0;
  static const double iconMedium = 20.0;
  static const double iconLarge = 24.0;
  static const double iconXLarge = 32.0;

  // Button Heights
  static const double buttonHeight = 48.0;
  static const double smallButtonHeight = 36.0;
  static const double compactButtonHeight = 32.0;

  // Elevation
  static const double lowElevation = 2.0;
  static const double mediumElevation = 4.0;
  static const double highElevation = 8.0;

  // Animation Durations
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);

  // const string literals
  static const String accessTokenKey = "access_token";
  static const String refreshTokenKey = "refresh_token";
}
