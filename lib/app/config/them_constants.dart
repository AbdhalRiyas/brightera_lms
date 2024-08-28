import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemConstants {
// Border Radius
  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 16.0;

  // Padding
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  // Colors
  static const Color primaryColor = Colors.blue;
  static const Color accentColor = Colors.blueAccent;

  // Font Sizes
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 20.0;

  // Image Sizes
  static const double imageSizeSmall = 24.0; // e.g., for small icons
  static const double imageSizeMedium = 48.0; // e.g., for profile pictures
  static const double imageSizeLarge =
      120.0; // e.g., for large banners or thumbnails

  // Elevation
  static const double cardElevation = 4.0;

  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
    brightness: Brightness.light,
    buttonTheme: const ButtonThemeData(buttonColor: Colors.blueAccent),
    textTheme: GoogleFonts.mulishTextTheme(),
  );

  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const TextStyle bodyTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.black54,
  );
}
