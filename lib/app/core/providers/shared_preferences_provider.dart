import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = FutureProvider<SharedPreferences>((
  ref,
) async {
  return await SharedPreferences.getInstance();
});

final sharedPreferencesSyncProvider = Provider<SharedPreferences>((ref) {
  final asyncValue = ref.watch(sharedPreferencesProvider);
  return asyncValue.when(
    data: (prefs) => prefs,
    loading: () => throw Exception('SharedPreferences not initialized yet'),
    error: (error, stack) => throw error,
  );
});
