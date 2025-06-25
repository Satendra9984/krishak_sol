import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Bhoomi Shakti App Themes
/// - Light and Dark themes with agriculture-inspired palette
/// - Uses Material 3
/// Theme usage guide:
///
/// - primary: Main brand color, prominent buttons, FAB, active elements, toggles, progress bars, selected items.
/// - onPrimary: Text/icons on primary color.
/// - secondary: Accent color, less prominent buttons, chips, selection controls, highlights.
/// - onSecondary: Text/icons on secondary color.
/// - background: App background, large surfaces, Scaffold background.
/// - onBackground: Text/icons on background color.
/// - surface: Cards, sheets, menus, dialogs, bottom nav, etc.
/// - onSurface: Text/icons on surface color.
/// - error: Error states, error buttons, error banners, etc.
/// - onError: Text/icons on error color.
///
/// Common widget mappings:
/// - AppBar: Uses surface/background, foregroundColor uses onSurface/onBackground
/// - ElevatedButton/FAB: Uses primary (background), onPrimary (foreground)
/// - Card/Dialog/Sheet: Uses surface, onSurface
/// - Scaffold: Uses background
/// - Text: Uses onBackground or onSurface depending on parent
/// - Icon: Uses onPrimary/onSecondary/onSurface
///
/// See: https://api.flutter.dev/flutter/material/ColorScheme-class.html
class BhoomiTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.inter().fontFamily,
      // ColorScheme defines core colors for your app's UI elements.
      colorScheme: ColorScheme.light(
        primary: const Color(
          0xFF04B150,
        ), // Deep Green. Use for main buttons, FAB, toggles, progress bars, selected items.
        onPrimary: Colors.white, // Text/icons on primary color.
        secondary: const Color(
          0xFFFFB300,
        ), // Harvest Yellow. Use for accent buttons, chips, selection controls.
        onSecondary: Colors.black, // Text/icons on secondary color.
        surface: Colors.white, // Cards, sheets, dialogs, menus, bottom nav.
        onSurface: const Color(0xFF222222), // Text/icons on surface.
        error: const Color(0xFFD32F2F), // Error states, error buttons, banners.
        onError: Colors.white, // Text/icons on error color.
      ),
      scaffoldBackgroundColor: const Color(0xFFFfffff),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF000000),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xFF000000),
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          // color: Color(0xFF388E3C),
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          // color: Color(0xFF388E3C),
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFF222222),
        ),
        bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF222222)),
        bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF444444)),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          // color: Color(0xFF388E3C),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF04B150),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
          padding: EdgeInsets.symmetric(vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF04B150), width: 2),
        ),
        labelStyle: const TextStyle(color: Color(0xFF04B150)),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      iconTheme: const IconThemeData(color: Color(0xFF04B150)),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFFFB300),
        foregroundColor: Colors.black,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Color(0xFF04B150),
        contentTextStyle: TextStyle(color: Colors.white),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: GoogleFonts.inter().fontFamily,

      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: const Color(0xFF04B150), // Lighter green
        onPrimary: Colors.black,
        secondary: const Color(0xFFFFE082), // Lighter yellow
        onSecondary: Colors.black,
        surface: const Color(0xFF263238),
        onSurface: Colors.white,
        error: const Color(0xFFD32F2F),
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFF222E24),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF263238),
        foregroundColor: Color(0xFF04B150),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Color(0xFF04B150),
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Color(0xFF04B150),
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF04B150),
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
        bodyMedium: TextStyle(fontSize: 14, color: Color(0xFFB0BEC5)),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF04B150),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF04B150),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
          padding: EdgeInsets.symmetric(vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF263238),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF04B150), width: 2),
        ),
        labelStyle: const TextStyle(color: Color(0xFFD9D9D9)),
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF263238),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      iconTheme: const IconThemeData(color: Color(0xFF81C784)),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFFFE082),
        foregroundColor: Colors.black,
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Color(0xFF04B150),
        contentTextStyle: TextStyle(color: Colors.black),
      ),
    );
  }
}
