import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:bhoomi_sakti/app/core/services/token_storage_service.dart';
import 'package:bhoomi_sakti/app/core/services/token_storage_service_impl.dart';

// Provider for FlutterSecureStorage
final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );
});

// Provider for TokenStorageService
final tokenStorageServiceProvider = Provider<TokenStorageService>((ref) {
  final secureStorage = ref.watch(flutterSecureStorageProvider);
  return TokenStorageServiceImpl(secureStorage: secureStorage);
});
