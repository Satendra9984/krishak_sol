// Placeholder for initial screen - replace with your actual initial screen
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // The AuthNotifier.checkAuthStatus() is called upon its initialization
    // when GoRouter first accesses it. GoRouter's redirect logic will handle
    // navigation based on the AuthState.
    // This screen just shows a loading indicator while that check happens.
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
