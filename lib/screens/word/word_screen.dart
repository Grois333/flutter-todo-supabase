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
class WordListScreen extends ConsumerStatefulWidget {
  const WordListScreen({super.key});

  @override
  _WordListScreenState createState() => _WordListScreenState();
}

class _WordListScreenState extends ConsumerState<WordListScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final words = ref.watch(wordProvider);
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: const AppHeader(title: 'Word List'),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: kPrimaryColor, width: 1.0),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: AnimationLimiter(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: words.length,
                    itemBuilder: (context, index) {
                      final word = words[index];
                      final isUserWord = word.user_id == user?.id;
                      final isNew =
                          index == words.length - 1; // Highlight latest word

                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 300),
                        child: SlideAnimation(
                          verticalOffset: 30.0,
                          child: FadeInAnimation(
                            child: WordItem(
                              word: word.word,
                              isUserWord: isUserWord,
                              isNew: isNew,
                              onDelete: () async {
                                if (await confirm(
                                  context,
                                  title: const Text(
                                      'Are you sure you want to delete this word?'),
                                  textOK: const Text('Yes'),
                                  textCancel: const Text('No'),
                                )) {
                                  ref
                                      .read(wordProvider.notifier)
                                      .deleteWord(word.id);
                                }
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
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
                    if (_controller.text.trim().isNotEmpty) {
                      ref
                          .read(wordProvider.notifier)
                          .addWord(_controller.text.trim());
                      _controller.clear();
                      _scrollToBottom(); // Scroll to the new word
                    }
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

/// WordItem with animated background color transition (grey → white)
class WordItem extends StatefulWidget {
  final String word;
  final bool isUserWord;
  final bool isNew;
  final VoidCallback? onDelete;

  const WordItem({
    Key? key,
    required this.word,
    required this.isUserWord,
    this.isNew = false,
    this.onDelete,
  }) : super(key: key);

  @override
  _WordItemState createState() => _WordItemState();
}

class _WordItemState extends State<WordItem> {
  Color _backgroundColor = Colors.grey.shade300;

  @override
  void initState() {
    super.initState();
    if (widget.isNew) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            _backgroundColor = Colors.white;
          });
        }
      });
    } else {
      _backgroundColor = Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOut,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 3,
            offset: const Offset(1, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              widget.word,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (widget.isUserWord)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: widget.onDelete,
            ),
        ],
      ),
    );
  }
}
