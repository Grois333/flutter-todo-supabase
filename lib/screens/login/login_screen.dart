import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_word_app/providers/loading_provider.dart';
import 'package:supabase_word_app/utils/loading_overlay.dart';
import '../../utils/responsive.dart';
import './components/login_form.dart';

@RoutePage()
class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loadingProvider);

    return Scaffold(
      body: LoadingOverlay(
        isLoading: isLoading,
        child: Center(
          child: SingleChildScrollView(
            child: Responsive(
              mobile: MobileLoginScreen(),
              desktop: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 450,
                          child:
                              FadeInLoginForm(), // FadeIn version of the LoginForm
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FadeInLoginForm extends StatefulWidget {
  const FadeInLoginForm({Key? key}) : super(key: key);

  @override
  _FadeInLoginFormState createState() => _FadeInLoginFormState();
}

class _FadeInLoginFormState extends State<FadeInLoginForm> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    _fadeInForm();
  }

  void _fadeInForm() async {
    await Future.delayed(
        const Duration(milliseconds: 500)); // Delay before starting animation
    setState(() {
      _opacity = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(seconds: 1), // Duration of the fade-in animation
      child: const LoginForm(),
    );
  }
}

class MobileLoginScreen extends StatelessWidget {
  const MobileLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          children: [
            Spacer(),
            Expanded(
              flex: 8,
              child: LoginForm(),
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }
}
