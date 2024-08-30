import 'package:flutter/material.dart';

class ThemeConstants {
// Border Radius
  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 16.0;

  // Padding
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  // Colors
  static const Color primaryColor = Color(0xFFe0b9d7);
  static const Color accentColor = Color.fromARGB(255, 255, 195, 142);
  static const Color backgroundColor = Colors.white;
  static const Color almondMilk = Color(0xFFF1EDE9);
  static const Color lavenderMist = Color(0xFFE6DFF1);
  static const Color aqua = Color(0xFFC0DEDB);

  static const Color primaryButtonColor = Colors.black;
  static const Color primaryButtonTextColor = Colors.white;

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

  // static final ThemeData lightTheme = ThemeData(
  //   colorSchemeSeed: primaryColor,
  //   useMaterial3: true,
  //   brightness: Brightness.light,
  //   // buttonTheme: const ButtonThemeData(buttonColor: Colors.blueAccent),
  //   textTheme: GoogleFonts.mavenProTextTheme(),
  // );

  static final ThemeData lightTheme = ThemeData(
    colorSchemeSeed: primaryColor,
    useMaterial3: true,
    brightness: Brightness.light,
    // buttonTheme: const ButtonThemeData(buttonColor: Colors.blueAccent),
    fontFamily: 'Poppins',
    textTheme: const TextTheme(),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedIconTheme: IconThemeData(
        color: accentColor,
      ),
      selectedLabelStyle: TextStyle(
        color: accentColor,
      ),
    ),
    cardTheme: CardTheme(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadiusLarge),
      ),
    ),
  );

  static const TextStyle headingStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Color(0xFF020202),
  );

  static const TextStyle bodyTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.black54,
  );
}
