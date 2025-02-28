import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_word_app/app_router.dart';
import 'package:supabase_word_app/components/signin_oauth.dart';
import 'package:supabase_word_app/providers/loading_provider.dart';
import '../../../components/already_have_an_account_acheck.dart';
import '../../../constants/constants.dart';
import '../../../services/supabase_service.dart';

class SignUpForm extends ConsumerWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>(); // Form key
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();
    final SupabaseService supabaseService = SupabaseService();

    Future<void> handleSignup(BuildContext context) async {
      if (formKey.currentState!.validate()) {
        ref.read(loadingProvider.notifier).setLoading(true);

        try {
          await supabaseService.signUp(
            emailController.text.trim(),
            passwordController.text.trim(),
          );
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Signup successful.')),
            );

            // Navigate to Home Screen after successful signup
            context.router.replace(const WordListRoute());
          }
        } catch (error) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Signup failed: $error')),
            );
          }
        } finally {
          ref.read(loadingProvider.notifier).setLoading(false);
        }
      }
    }

    return Column(
      children: [
        Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                cursorColor: kPrimaryColor,
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: "Your email",
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: Icon(Icons.person),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email is required";
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return "Enter a valid email";
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: defaultPadding),
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  obscureText: true,
                  cursorColor: kPrimaryColor,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    hintText: "Your password",
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(defaultPadding),
                      child: Icon(Icons.lock),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    } else if (value.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                ),
              ),
              TextFormField(
                textInputAction: TextInputAction.done,
                obscureText: true,
                cursorColor: kPrimaryColor,
                controller: confirmPasswordController,
                decoration: const InputDecoration(
                  hintText: "Confirm password",
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(defaultPadding),
                    child: Icon(Icons.lock),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Confirm password is required";
                  } else if (value != passwordController.text) {
                    return "Passwords do not match";
                  }
                  return null;
                },
              ),
              const SizedBox(height: defaultPadding / 2),
              ElevatedButton(
                onPressed: () => handleSignup(context),
                child: Text("Sign Up".toUpperCase()),
              ),
              const SizedBox(height: defaultPadding),
              AlreadyHaveAnAccountCheck(
                login: false,
                press: () {
                  context.router.replace(const LoginRoute());
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Add social login buttons at the bottom
        const SignInOauth(),
      ],
    );
  }
}
