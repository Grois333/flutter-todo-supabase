import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_word_app/constants/constants.dart';

class SupabaseService {
  final SupabaseClient supabase = Supabase.instance.client;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: iosClientId,
    serverClientId: googleClientId, // Make sure this is set correctly
  );
  final logger = Logger();

  // Check if user is logged in
  User? getCurrentUser() {
    return supabase.auth.currentUser;
  }

  // Listen to auth state changes
  Stream<AuthState> onAuthStateChange() {
    return supabase.auth.onAuthStateChange;
  }

  Future<void> login(String email, String password) async {
    await supabase.auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signUp(String email, String password) async {
    final response =
        await supabase.auth.signUp(email: email, password: password);
    return response;
  }

  Future<void> logout() async {
    await GoogleSignIn().signOut();
    await supabase.auth.signOut();
  }

  // Google Sign-In logic in SupabaseService
  Future<bool> googleSignInFunction() async {
    try {
      await _googleSignIn.signOut();
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // If the user cancels the sign-in
        return false;
      }

      // Authenticate with Supabase using Google ID Token
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;
      final String? accessToken = googleAuth.accessToken;

      if (idToken != null && accessToken != null) {
        final response = await supabase.auth.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: idToken,
          accessToken: accessToken,
        );

        if (response.user == null) {
          throw Exception('Sign-In Canceled!');
        }
        return true;
      } else {
        return false;
      }
    } on AuthException catch (error) {
      logger.e('Error during Google sign-in', error: error);
      throw Exception('Error during Google sign-in: ${error.message}');
    } catch (error) {
      logger.e('Error during Google sign-in:', error: error);
      throw Exception('Unexpected error: $error');
    }
  }
}
