import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'bhoomi_theme.dart';

/// Provides the current [ThemeData] for the app.
/// For now, always returns the light theme.
final currentThemeProvider = Provider<ThemeData>((ref) {
  return BhoomiTheme.lightTheme;
});
