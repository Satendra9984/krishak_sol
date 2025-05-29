// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:bhoomi_sakti/main.dart'; // Imports PlaceholderApp

void main() {
  testWidgets('PlaceholderApp shows default message', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PlaceholderApp());

    // Verify that the placeholder text is shown.
    expect(find.text('Bhoomi Shakti - Default Entry Point'), findsOneWidget);
    expect(
        find.text(
            'This is a placeholder app. Please run the app using a specific flavor entry point (e.g., lib/main_dev.dart or lib/main_prod.dart). ',
            findRichText: true),
        findsOneWidget);
  });
}

