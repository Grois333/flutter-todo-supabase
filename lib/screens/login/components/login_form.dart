import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_word_app/app_router.dart';
import 'package:supabase_word_app/components/signin_oauth.dart';
import 'package:supabase_word_app/providers/loading_provider.dart';
import 'package:supabase_word_app/utils/validators.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants/constants.dart';
import '../../../services/supabase_service.dart';

class LoginForm extends ConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final supabaseService = SupabaseService();

    Future<void> handleLogin(BuildContext context) async {
      if (formKey.currentState!.validate()) {
        ref.read(loadingProvider.notifier).setLoading(true);

        try {
          await supabaseService.login(
              emailController.text.trim(), passwordController.text.trim());

          if (!context.mounted) return;
          context.router.replace(const WordListRoute());
        } catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed: $error')),
          );
        } finally {
          ref.read(loadingProvider.notifier).setLoading(false);
        }
      }
    }

    return Column(children: [
      Form(
        key: formKey, // Assign key
        child: Column(
          children: [
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "Your email",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!isValidEmail(value)) {
                  return 'Enter a valid email';
                }

                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defaultPadding),
              child: TextFormField(
                controller: passwordController,
                textInputAction: TextInputAction.done,
                obscureText: true,
                cursorColor: kPrimaryColor,
                decoration: const InputDecoration(
                  hintText: "Your password",
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: Icon(Icons.lock),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (!isValidPassword(value)) {
                    return 'Password must be at least 6 characters';
                  }

                  return null;
                },
              ),
            ),
            const SizedBox(height: defaultPadding),
            ElevatedButton(
              onPressed: () => handleLogin(context),
              child: Text("Login".toUpperCase()),
            ),
            const SizedBox(height: defaultPadding),
            AlreadyHaveAnAccountCheck(
              press: () {
                context.router.replace(const SignUpRoute());
              },
            ),
          ],
        ),
      ),

      const SizedBox(height: 20),

      // Add social login buttons at the bottom
      const SignInOauth(),
    ]);
  }
}
