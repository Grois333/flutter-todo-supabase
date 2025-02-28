import 'package:flutter_riverpod/flutter_riverpod.dart';

final loadingProvider = StateNotifierProvider<LoadingNotifier, bool>((ref) {
  return LoadingNotifier();
});

class LoadingNotifier extends StateNotifier<bool> {
  LoadingNotifier() : super(false);

  void setLoading(bool loadingState) {
    state = loadingState;
  }
}
