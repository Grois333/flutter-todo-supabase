import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_word_app/app_router.dart';
import 'package:supabase_word_app/components/app_header.dart';

@RoutePage()
class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const AppHeader(title: "Home"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => {context.router.replace(const WordListRoute())},
              child: Text("Word".toUpperCase()),
            ),
          ],
        ),
      ),
    );
  }
}
