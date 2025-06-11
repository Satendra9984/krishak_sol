import 'package:bhoomi_sakti/app/core/providers/shared_preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bhoomi_sakti/features/app.dart';
import 'package:bhoomi_sakti/app/config/flavors/flavor_config.dart'; // Added import
import 'package:shared_preferences/shared_preferences.dart'; // For SharedPreferences

// TODO: Import your Isar schemas here
// import 'package:bhoomi_sakti/features/some_feature/data/models/some_schema.dart';

Future<void> mainCommon(FlavorConfig flavorConfig) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // FlutterSecureStorage storage = FlutterSecureStorage(
  //   aOptions: AndroidOptions(encryptedSharedPreferences: true),
  //   iOptions: IOSOptions(
  //     accessibility: KeychainAccessibility.first_unlock_this_device,
  //   ),
  // );

  // Initialize Isar
  // final dir = await getApplicationDocumentsDirectory();
  // final isar = await Isar.open(
  //   [], // TODO: Add your IsarCollectionSchema instances here (e.g. [SomeSchemaSchema])
  //   directory: dir.path,
  //   name: 'bhoomi_sakti_cache',
  // );

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const BhoomiSaktiApp(),
    ),
  );
}

// Reminder: Define isarInstanceProvider in riverpod_providers.dart
// final isarInstanceProvider = Provider<Isar>((ref) {
//   throw UnimplementedError('Isar instance provider must be overridden in ProviderScope');
// });
