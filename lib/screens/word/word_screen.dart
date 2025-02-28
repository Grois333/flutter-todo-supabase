import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:supabase_word_app/components/app_header.dart';
import 'package:supabase_word_app/constants/constants.dart';
import 'package:supabase_word_app/providers/user_provider.dart';
import 'package:supabase_word_app/providers/word_provider.dart';

@RoutePage()
class WordListScreen extends ConsumerWidget {
  const WordListScreen({super.key}); // Use Key? key if you need it

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final words = ref.watch(wordProvider);
    final user = ref.watch(userProvider);
    final TextEditingController _controller = TextEditingController();

    return Scaffold(
      appBar: const AppHeader(title: 'Word List'),
      body: Padding(
        padding: const EdgeInsets.all(5), // Global padding of 5 for the body
        child: Column(
          children: [
            // Container for ListView with border and fixed height (70% of screen)
            Container(
              height: MediaQuery.of(context).size.height * 0.70,
              decoration: BoxDecoration(
                border: Border.all(color: kPrimaryColor, width: 1.0),
                borderRadius: BorderRadius.circular(5),
              ),
              child: AnimationLimiter(
                child: ListView.builder(
                  itemCount: words.length,
                  itemBuilder: (context, index) {
                    final word = words[index];
                    final isUserWord = word.user_id == user?.id;
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: ListTile(
                            title: Text(word.word),
                            trailing: isUserWord
                                ? IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () async {
                                      if (await confirm(
                                        context,
                                        title: const Text(
                                            'Are you sure delete word?'),
                                        textOK: const Text('Yes'),
                                        textCancel: const Text('No'),
                                      )) {
                                        ref
                                            .read(wordProvider.notifier)
                                            .deleteWord(word.id);
                                      }
                                    },
                                  )
                                : null,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: "New Word",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                ElevatedButton(
                  onPressed: () {
                    ref.read(wordProvider.notifier).addWord(_controller.text);
                    _controller.clear();
                  },
                  child: const Text("Add"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
