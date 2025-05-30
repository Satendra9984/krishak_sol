import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bhoomi_sakti/features/app.dart';
import 'package:bhoomi_sakti/app/config/flavors/flavor_config.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:bhoomi_sakti/app/core/di/riverpod_providers.dart'; // Added import

// TODO: Import your Isar schemas here
// import 'package:bhoomi_sakti/features/some_feature/data/models/some_schema.dart';

Future<void> mainCommon(FlavorConfig flavorConfig) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Isar
  // final dir = await getApplicationDocumentsDirectory();
  // final isar = await Isar.open(
  //   [], // TODO: Add your IsarCollectionSchema instances here (e.g. [SomeSchemaSchema])
  //   directory: dir.path,
  //   name: 'bhoomi_sakti_cache',
  // );

  runApp(
    ProviderScope(
      overrides: [
        // Make Isar instance available via a provider
        // Ensure riverpod_providers.dart has `isarInstanceProvider` defined.
        // Example: final isarInstanceProvider = Provider<Isar>((ref) => throw UnimplementedError());
        // This line will override that definition with the actual Isar instance.
        // Adjust if your provider is named differently or if you have a specific type for it.
        // Assuming 'isarInstanceProvider' is defined in 'riverpod_providers.dart'
        // and needs to be overridden here.
        // If 'isarInstanceProvider' is not yet created, you'll need to define it first.
        // For now, we'll assume it exists and needs this override.
        // import 'package:bhoomi_sakti/app/core/di/riverpod_providers.dart'; // Ensure this import if not present
        // isarInstanceProvider.overrideWithValue(isar), // This line will cause an error if isarInstanceProvider is not imported or defined.
        // isarInstanceProvider.overrideWithValue(isar), // This line will cause an error if isarInstanceProvider is not imported or defined.
        // For now, let's add a placeholder for the provider override.
        // You will need to define `isarInstanceProvider` in `riverpod_providers.dart` like:
        // final isarInstanceProvider = Provider<Isar>((ref) => throw UnimplementedError('Isar instance not provided'));
        // Then uncomment the line below after ensuring the provider is imported.
        // isarInstanceProvider.overrideWithValue(isar),
      ],
      child: const BhoomiSaktiApp(),
    ),
  );
}

// Reminder: Define isarInstanceProvider in riverpod_providers.dart
// final isarInstanceProvider = Provider<Isar>((ref) {
//   throw UnimplementedError('Isar instance provider must be overridden in ProviderScope');
// });
