import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_word_app/app_router.dart';
import 'package:supabase_word_app/providers/loading_provider.dart';
import 'package:supabase_word_app/services/supabase_service.dart';

class SignInOauth extends ConsumerStatefulWidget {
  const SignInOauth({super.key});

  @override
  SignInOauthState createState() => SignInOauthState();
}

class SignInOauthState extends ConsumerState<SignInOauth>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _googleAnimation;
  late Animation<double> _facebookAnimation;
  late Animation<double> _appleAnimation;

  final SupabaseService supabaseService = SupabaseService();

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // Create animations for the buttons
    _googleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -5), weight: 50),
      TweenSequenceItem(tween: Tween(begin: -5, end: 5), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 5, end: 0), weight: 50),
    ]).animate(_controller);

    _facebookAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 5), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 5, end: -5), weight: 50),
      TweenSequenceItem(tween: Tween(begin: -5, end: 0), weight: 50),
    ]).animate(_controller);

    _appleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -5), weight: 50),
      TweenSequenceItem(tween: Tween(begin: -5, end: 5), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 5, end: 0), weight: 50),
    ]).animate(_controller);

    // Start the animation
    _controller.repeat(reverse: true, period: const Duration(seconds: 1));

    // Stop animation after 3 seconds
    Future.delayed(const Duration(seconds: 2), () {
      _controller.stop();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Google Sign-In Function
  Future<void> googleSignInFunction(BuildContext context) async {
    ref.read(loadingProvider.notifier).setLoading(true);

    try {
      bool isSignedIn = await supabaseService.googleSignInFunction();
      if (isSignedIn) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google OAuth Successfully logged!')),
        );
        context.router.replace(const WordListRoute());
      }
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$error')),
      );
    } finally {
      ref.read(loadingProvider.notifier).setLoading(false);
    }
  }

  // Animated Button Builder
  Widget _buildAnimatedButton(Animation<double> animation, IconData icon,
      Color color, VoidCallback onPressed) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, animation.value),
          child: GestureDetector(
            onTapDown: (_) => setState(() => _controller.stop()),
            onTapUp: (_) => _controller.forward(),
            onTap: onPressed, // Trigger action on button tap
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.white,
              child: FaIcon(icon, color: color, size: 30),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildAnimatedButton(
          _googleAnimation,
          FontAwesomeIcons.google,
          Colors.red,
          () => googleSignInFunction(context), // Google Sign-In action
        ),
        const SizedBox(width: 20),
        _buildAnimatedButton(
          _facebookAnimation,
          FontAwesomeIcons.facebook,
          Colors.blue,
          () {
            // Facebook OAuth logic here (if required)
          },
        ),
        const SizedBox(width: 20),
        _buildAnimatedButton(
          _appleAnimation,
          FontAwesomeIcons.apple,
          Colors.black,
          () {
            // Apple OAuth logic here (if required)
          },
        ),
      ],
    );
  }
}
