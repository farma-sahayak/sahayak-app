import 'package:flutter/material.dart';

// Replace these color values with those extracted from the UI mockup
const Color primaryColor = Color(0xFF388E3C); // Example: Green
const Color secondaryColor = Color(0xFFFFA726); // Example: Orange
const Color backgroundColor = Color(0xFFF5F5F5); // Example: Light Grey
const Color accentColor = Color(0xFF1976D2); // Example: Blue
const Color surfaceColor = Color(0xFFFFFFFF);
const Color errorColor = Color(0xFFD32F2F);

final ColorScheme sahayakColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: primaryColor,
  onPrimary: Colors.white,
  secondary: secondaryColor,
  onSecondary: Colors.white,
  background: backgroundColor,
  onBackground: Colors.black,
  surface: surfaceColor,
  onSurface: Colors.black,
  error: errorColor,
  onError: Colors.white,
);

ThemeData getSahayakTheme() {
  return ThemeData(
    colorScheme: sahayakColorScheme,
    useMaterial3: true,
    fontFamily: 'Roboto',
    scaffoldBackgroundColor: backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    cardTheme: CardThemeData(
      color: surfaceColor,
      elevation: 2,
      margin: const EdgeInsets.all(8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: primaryColor,
      textTheme: ButtonTextTheme.primary,
    ),
  );
}
