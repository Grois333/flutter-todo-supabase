import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_word_app/app_router.dart';
import 'services/supabase_service.dart';
import 'constants/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SupabaseService supabaseService = SupabaseService();
  late Stream<AuthState> authStateStream;
  final _appRouter = AppRouter();

  @override
  void initState() {
    super.initState();
    authStateStream = supabaseService.onAuthStateChange();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: authStateStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
              home: Scaffold(body: Center(child: CircularProgressIndicator())));
        }

        final session = Supabase.instance.client.auth.currentSession;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (session != null) {
            _appRouter.replace(WordListRoute());
          } else {
            _appRouter.replace(LoginRoute());
          }
        });

        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: _appRouter.config(),
        );
      },
    );
  }
}
