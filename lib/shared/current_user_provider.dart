import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bhoomi_sakti/features/auth/presentation/blocs/auth_notifier/auth_state.dart';
import 'package:bhoomi_sakti/features/auth/domain/entities/user_entity.dart';
import 'package:bhoomi_sakti/features/auth/auth_providers.dart';

/// Provides the current authenticated user profile, or null if not authenticated.
final currentUserProvider = Provider<UserEntity?>((ref) {
  final authState = ref.watch(authNotifierProvider);
  if (authState is Authenticated) {
    return authState.user;
  }
  return null;
});
