import 'package:bhoomi_sakti/common/app_common_providers.dart';
import 'package:bhoomi_sakti/common/providers/auth_notifier/auth_notifier.dart';
import 'package:bhoomi_sakti/common/providers/auth_notifier/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final userNotifierProvider = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Profile')),
      body: Consumer(
        builder: (context, ref, child) {
          final userNotifierProvider = ref.watch(authNotifierProvider);
          if (userNotifierProvider is Authenticated) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),

              child: Column(
                // alignemt
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: theme.colorScheme.primary.withAlpha(150),
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    userNotifierProvider.user.name,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Text(
                    userNotifierProvider.user.role,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // profile options

                  // mobile number option
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primary.withAlpha(100),
                      child: const Icon(Icons.phone),
                    ),
                    title: Text(
                      'Mobile Number',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    subtitle: Text(
                      '+91 ${userNotifierProvider.user.mobileNumber}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      context.push('/mobile-number');
                    },
                  ),

                  // 1. orders
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primary.withAlpha(100),
                      child: const Icon(Icons.shopping_cart),
                    ),
                    title: Text(
                      'Orders',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'View all orders',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      context.push('/orders');
                    },
                  ),

                  // 2. transactions
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primary.withAlpha(100),
                      child: const Icon(Icons.attach_money),
                    ),
                    title: Text(
                      'Transactions',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'View all transactions',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      context.push('/transactions');
                    },
                  ),

                  // soil tests
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primary.withAlpha(100),
                      child: const Icon(Icons.attach_money),
                    ),
                    title: Text(
                      'Soil Tests',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'View all soil tests',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      context.push('/soil-tests');
                    },
                  ),

                  // 3. logout
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.error.withAlpha(100),
                      child: const Icon(Icons.logout),
                    ),
                    title: Text(
                      'Logout',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Logout from your account',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      ref.read(authNotifierProvider.notifier).loggedOut();
                    },
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('User not authenticated'));
        },
      ),
    );
  }
}
