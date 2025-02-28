import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_word_app/models/user_model.dart';
import 'package:supabase_word_app/models/word_model.dart';
import 'package:supabase_word_app/providers/user_provider.dart';

final supabase = Supabase.instance.client;

class WordNotifier extends StateNotifier<List<WordModel>> {
  WordNotifier(this.ref) : super([]) {
    fetchWordsAll();
    _subscribeToWords(); // Start the real-time subscription
  }

  final Ref ref;
  UserModel? get user => ref.read(userProvider);

  // Fetch all words for all users (not filtered by user_id)
  Future<void> fetchWordsAll() async {
    final response =
        await supabase.from('words').select(); // Fetch words for all users

    // Map the Supabase response to a list of WordModel
    state = response.map<WordModel>((word) {
      return WordModel(
        id: word['id'] as int,
        word: word['word'] as String,
        user_id: word['user_id'] as String,
      );
    }).toList();
  }

  // Real-time subscription for insert, update, and delete events
  void _subscribeToWords() {
    supabase
        .channel('public:words')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'words',
          callback: (payload) {
            if (user?.id != payload.newRecord['user_id'] as String) {
              final newWord = WordModel(
                id: payload.newRecord['id'] as int,
                word: payload.newRecord['word'] as String,
                user_id: payload.newRecord['user_id'] as String,
              );
              state = [...state, newWord]; // Add the new word to the state
            }
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'words',
          callback: (payload) {
            if (user?.id != payload.newRecord['user_id'] as String) {
              final updatedWord = WordModel(
                id: payload.newRecord['id'] as int,
                word: payload.newRecord['word'] as String,
                user_id: payload.newRecord['user_id'] as String,
              );
              state = state
                  .map((word) => word.id == updatedWord.id ? updatedWord : word)
                  .toList(); // Update the word
            }
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: 'words',
          callback: (payload) {
            state = state
                .where((word) => word.id != payload.oldRecord['id'] as int)
                .toList(); // Remove deleted word
          },
        )
        .subscribe(); // Begin subscription to real-time changes
  }

  // Add new word (user's ID will be saved with the word)
  Future<void> addWord(String newWord) async {
    final user = ref.read(userProvider);
    if (user == null) return;

    newWord = newWord.trim();
    if (newWord.isEmpty) return;

    final response = await supabase
        .from('words')
        .insert({
          'word': newWord,
          'user_id': user.id, // Store the user's ID with the word
        })
        .select()
        .single();
    state = [
      ...state,
      WordModel(
        id: response['id'] as int,
        word: response['word'] as String,
        user_id: response['user_id'] as String,
      )
    ];
    // Fetch the total count of words for the authenticated user
    final countResponse =
        await supabase.from('words').select('id').eq('user_id', user.id);

    int wordCount = countResponse.length;

    // Check if the word count matches the predefined milestones
    if ([5, 12, 17, 21, 25].contains(wordCount)) {
      Fluttertoast.showToast(
        msg: "You have $wordCount words!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  // Delete word only for the authenticated user
  Future<void> deleteWord(int id) async {
    final user = ref.read(userProvider);
    if (user == null) return;

    await supabase
        .from('words')
        .delete()
        .eq('id', id)
        .eq('user_id', user.id); // Ensure only user's words are deleted

    fetchWordsAll(); // Refresh list after deletion
  }
}

// Riverpod Provider for WordNotifier
final wordProvider =
    StateNotifierProvider<WordNotifier, List<WordModel>>((ref) {
  return WordNotifier(ref);
});
