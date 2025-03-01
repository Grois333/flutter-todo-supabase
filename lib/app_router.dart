import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:supabase_word_app/screens/home_screen.dart';
import 'package:supabase_word_app/screens/login/login_screen.dart';
import 'package:supabase_word_app/screens/signup/signup_screen.dart';
import 'package:supabase_word_app/screens/word/word_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
@AutoRouter()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        CustomRoute(
          page: LoginRoute.page,
          initial: true,
          transitionsBuilder: _leftToRightTransition,
          durationInMilliseconds: 400, // Adjust animation speed
        ),
        CustomRoute(
          page: WordListRoute.page,
          transitionsBuilder: _leftToRightTransition,
          durationInMilliseconds: 400,
        ),
        CustomRoute(
          page: HomeRoute.page,
          transitionsBuilder: _leftToRightTransition,
          durationInMilliseconds: 400,
        ),
        CustomRoute(
          page: SignUpRoute.page,
          transitionsBuilder: _leftToRightTransition,
          durationInMilliseconds: 400,
        ),
      ];
}

/// Left-to-right transition function
Widget _leftToRightTransition(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  const begin = Offset(-1.0, 0.0); // Start off-screen to the left
  const end = Offset.zero; // End at normal position
  const curve = Curves.easeInOut; // Smooth transition

  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

  return SlideTransition(
    position: animation.drive(tween),
    child: child,
  );
}
