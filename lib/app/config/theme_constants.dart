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
  static const Color primaryColor = Color(0xFF7E017E);
  static const Color accentColor = Color(0xFFFE1BFE);
  static const Color borderColor = Color.fromARGB(255, 221, 220, 221);
  static const Color backgroundColor = Color(0xFFF4F4F4);
  static const Color lavenderMist = Color(0xFFE6DFF1);
  static const Color inputFieldFill = Color(0xFFEBE0EB);
  static const Color primaryShadowColor = Color(0xFFD6C2D6);

  static const Color primaryButtonColor = primaryColor;
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

  // Brderd Sizes
  static const double borderSizeSmall = 1 / 2;
  static const double borderSizeMedium = 1;
  static const double borderSizeLarge = 2;

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
    canvasColor: backgroundColor,
    scaffoldBackgroundColor: backgroundColor,
    useMaterial3: true,
    brightness: Brightness.light,
    // buttonTheme: const ButtonThemeData(buttonColor: Colors.blueAccent),
    fontFamily: 'Poppins',
    textTheme: const TextTheme(),
    appBarTheme: const AppBarTheme(
      backgroundColor: backgroundColor,
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        color: Color(0xFF1F141F),
        fontSize: 22,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: primaryButtonTextColor,
      backgroundColor: primaryButtonColor,
    ),
    inputDecorationTheme:
        const InputDecorationTheme(fillColor: Color(0xFFEBE0EB)),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          backgroundColor: primaryButtonColor,
          foregroundColor: primaryButtonTextColor,
          minimumSize: const Size.fromHeight(50),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadiusMedium))),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      elevation: 0,
      backgroundColor: backgroundColor,
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
    color: Color(0xFF1F141F),
  );

  static const TextStyle bodyTextStyle = TextStyle(
    fontSize: 16,
    color: Color(0xFF1F141F),
  );
}
