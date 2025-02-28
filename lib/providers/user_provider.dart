import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_word_app/models/user_model.dart';
import 'package:supabase_word_app/services/supabase_service.dart';

final supabase = Supabase.instance.client;
final SupabaseService supabaseService = SupabaseService();

// User provider
final userProvider = StateNotifierProvider<UserNotifier, UserModel?>((ref) {
  return UserNotifier();
});

// StateNotifier for user state
class UserNotifier extends StateNotifier<UserModel?> {
  UserNotifier() : super(null) {
    _authListener();
    loadUser();
  }

  void _authListener() {
    supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;

      if (event == AuthChangeEvent.signedIn) {
        loadUser(); // Refresh user data on login
      } else if (event == AuthChangeEvent.signedOut) {
        state = null; // Reset state on logout
      }
    });
  }

  // Load user from Supabase
  Future<void> loadUser() async {
    final session = supabase.auth.currentSession;
    if (session == null) return;

    final res = await supabase.auth.getUser();

    final userId = res.user?.id ?? '';
    final userEmail = res.user?.email ?? '';
    final userName = res.user?.userMetadata?['full_name'] ?? '';

    state = UserModel(id: userId, email: userEmail, name: userName);
  }

  // Logout user
  Future<void> logout() async {
    await supabaseService.logout();
    state = null;
  }
}
