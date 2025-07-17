import 'package:flutter/material.dart';

void main() {
  // This is the default main.dart file.
  // For this project, please use flavor-specific entry points:
  //
  // For Development: Use lib/main_dev.dart
  //   Run with: flutter run -t lib/main_dev.dart
  //
  // For Production: Use lib/main_prod.dart
  //   Run with: flutter run -t lib/main_prod.dart --release
  //
  // You will need to configure your IDE (VS Code, Android Studio) launch configurations
  // to use these different entry points for easier development and building.

  runApp(const PlaceholderApp());
}

class PlaceholderApp extends StatelessWidget {
  const PlaceholderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Bhoomi Shakti - Default Entry Point'),
        ),
        body: const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'This is a placeholder app. Please run the app using a specific flavor entry point (e.g., lib/main_dev.dart or lib/main_prod.dart). ',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
