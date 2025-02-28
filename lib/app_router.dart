import 'package:auto_route/auto_route.dart';
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
        AutoRoute(page: LoginRoute.page, initial: true),
        AutoRoute(page: WordListRoute.page),
        AutoRoute(page: HomeRoute.page),
        AutoRoute(page: SignUpRoute.page),
      ];
}
