import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth_mvvm/viewmodels/auth/user_view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<UserViewModel>();
    final user = vm.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            onPressed: () async {
              await vm.signOut();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
              }
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.verified_user, size: 64),
                const SizedBox(height: 12),
                Text(
                  'Welcome${user?.displayName != null ? ', ${user!.displayName}' : ''}!',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text('UID: ${user?.uid ?? '(none)'}', textAlign: TextAlign.center),
                if (user?.email != null) ...[
                  const SizedBox(height: 6),
                  Text('Email: ${user!.email}'),
                ],
                const SizedBox(height: 18),
                const Text(
                  'This page is gated behind Firebase Authentication.\n'
                  'User profile is upserted in Firestore under /users/{uid}.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
