import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_word_app/providers/user_provider.dart';
import 'package:supabase_word_app/app_router.dart';

class AppHeader extends ConsumerWidget implements PreferredSizeWidget {
  final String title;

  const AppHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    return AppBar(
      title: Text(title),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Center(
            child: Text(
              user?.name ?? (user?.email ?? ''),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            ref.read(userProvider.notifier).logout();
            context.router.replace(const LoginRoute());
          },
        ),
      ],
    );
  }

  // Implement preferredSize to define the height of the AppBar.
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
