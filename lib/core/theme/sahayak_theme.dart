import 'package:flutter/material.dart';

// App Color Palette
const Color primaryColor = Color(0xFF388E3C);
const Color primaryVariant = Color(0xFF2E7D32);
const Color secondaryColor = Color(0xFFFFA726);
const Color secondaryVariant = Color(0xFFFF9800);
const Color backgroundColor = Color(0xFFF5F5F5);
const Color surfaceColor = Color(0xFFFFFFFF);
const Color errorColor = Color(0xFFE53935);
const Color successColor = Color(0xFF4CAF50);
const Color warningColor = Color(0xFFFF9800);
const Color infoColor = Color(0xFF2196F3);

// Text Colors
const Color textPrimary = Color(0xFF212121);
const Color textSecondary = Color(0xFF757575);
const Color textHint = Color(0xFF9E9E9E);

// Surface Colors
const Color cardColor = Color(0xFFFFFFFF);
const Color greenLight = Color(0xFFE8F5E9);
const Color orangeLight = Color(0xFFFFF3E0);
const Color blueLight = Color(0xFFE3F2FD);
const Color redLight = Color(0xFFFFEBEE);

final ColorScheme sahayakColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: primaryColor,
  onPrimary: Colors.white,
  primaryContainer: greenLight,
  onPrimaryContainer: primaryVariant,
  secondary: secondaryColor,
  onSecondary: Colors.white,
  secondaryContainer: orangeLight,
  onSecondaryContainer: secondaryVariant,
  tertiary: infoColor,
  onTertiary: Colors.white,
  tertiaryContainer: blueLight,
  onTertiaryContainer: Color(0xFF1565C0),
  error: errorColor,
  onError: Colors.white,
  errorContainer: redLight,
  onErrorContainer: Color(0xFFC62828),
  surface: surfaceColor,
  onSurface: textPrimary,
  surfaceContainerHighest: Color(0xFFF8F9FA),
  onSurfaceVariant: textSecondary,
  outline: Color(0xFFE0E0E0),
  outlineVariant: Color(0xFFF5F5F5),
);

ThemeData getSahayakTheme() {
  return ThemeData(
    colorScheme: sahayakColorScheme,
    useMaterial3: true,
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: backgroundColor,

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      color: surfaceColor,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      shadowColor: Colors.black.withValues(alpha: 0.1),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      filled: true,
      fillColor: Colors.grey[50],
    ),

    // Text Theme
    textTheme: const TextTheme(
      // Headlines
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),

      // Titles
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),

      // Body
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textPrimary,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: textSecondary,
      ),

      // Labels
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimary,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textSecondary,
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: textHint,
      ),
    ),

    // Icon Theme
    iconTheme: const IconThemeData(color: textSecondary, size: 24),

    // Divider Theme
    dividerTheme: DividerThemeData(
      color: Colors.grey[200],
      thickness: 1,
      space: 1,
    ),
  );
}
