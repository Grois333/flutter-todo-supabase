import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_word_app/app_router.dart';
import 'package:supabase_word_app/providers/loading_provider.dart';
import 'package:supabase_word_app/services/supabase_service.dart';

class SignInOauth extends ConsumerWidget {
  const SignInOauth({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final supabaseService = SupabaseService();

    Future<void> googleSignInFunction(BuildContext context) async {
      ref.read(loadingProvider.notifier).setLoading(true);

      try {
        bool isSignedIn = await supabaseService.googleSignInFunction();
        if (isSignedIn) {
          context.router.replace(const WordListRoute());
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign-In failed!')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      } finally {
        ref.read(loadingProvider.notifier).setLoading(false);
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // Center the buttons
      children: [
        // Google Button
        GestureDetector(
          onTap: () => googleSignInFunction(context),
          child: CircleAvatar(
            radius: 20, // Adjust the size of the button
            backgroundColor: Colors.white,
            child: FaIcon(
              FontAwesomeIcons.google, // Google icon from FontAwesome
              color: Colors.red, // Google’s red color
              size: 30,
            ),
          ),
        ),
        const SizedBox(width: 20), // Space between the buttons

        // Facebook Button
        GestureDetector(
          onTap: () => {},
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: FaIcon(
              FontAwesomeIcons.facebook, // Facebook icon from FontAwesome
              color: Colors.blue, // Facebook’s blue color
              size: 30,
            ),
          ),
        ),
        const SizedBox(width: 20), // Space between the buttons

        // Apple Button
        GestureDetector(
          onTap: () => {},
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: FaIcon(
              FontAwesomeIcons.apple, // Apple icon from FontAwesome
              color: Colors.black, // Apple’s black color
              size: 30,
            ),
          ),
        ),
      ],
    );
  }
}
