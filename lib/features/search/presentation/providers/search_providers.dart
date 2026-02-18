import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/search_intent_model.dart';
import '../../data/repositories/search_repository.dart';
import '../../../../core/network/dio_provider.dart';

// --- State Definition ---
class SearchState {
  final bool isLoading;
  final SearchIntentModel? result;
  final String? error;

  const SearchState({
    this.isLoading = false,
    this.result,
    this.error,
  });

  SearchState copyWith({
    bool? isLoading,
    SearchIntentModel? result,
    String? error,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      result: result ?? this.result,
      error: error ?? this.error,
    );
  }
}

// --- Repository Provider ---
final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return SearchRepository(dio);
});

// --- Controller Notifier (Using Notifier instead of StateNotifier) ---
class SearchController extends Notifier<SearchState> {
  @override
  SearchState build() {
    return const SearchState();
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) return;
    
    // Set loading
    state = state.copyWith(isLoading: true, error: null);

    try {
      final repository = ref.read(searchRepositoryProvider);
      final intent = await repository.getIntent(query);
      
      // Set success
      state = state.copyWith(isLoading: false, result: intent);
    } catch (e) {
      // Set error
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
  
  void reset() {
    state = const SearchState();
  }
}

final searchControllerProvider = NotifierProvider<SearchController, SearchState>(SearchController.new);
