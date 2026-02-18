import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/search_providers.dart';
import '../../result/presentation/place_card.dart';
import '../../result/presentation/vehicle_card.dart';
import '../data/models/search_intent_model.dart';
import 'widgets/search_loading_view.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final double _userLat = 40.7128;
  final double _userLng = -74.0060;

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isNotEmpty) {
      ref.read(searchControllerProvider.notifier).search(query);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchControllerProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C1E),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            style: const TextStyle(color: Color(0xFFF5F5F7), fontSize: 15),
            decoration: InputDecoration(
              hintText: 'Search...',
              hintStyle: const TextStyle(color: Color(0xFF636366)),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              isDense: true,
              suffixIcon: IconButton(
                icon: const Icon(Icons.arrow_forward_rounded, size: 18, color: Color(0xFF8E8E93)),
                onPressed: _performSearch,
              ),
            ),
            onSubmitted: (_) => _performSearch(),
          ),
        ),
      ),
      body: _buildBody(searchState, theme),
    );
  }

  Widget _buildBody(SearchState state, ThemeData theme) {
    if (state.isLoading) {
      return const SearchLoadingView();
    }

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off_rounded, size: 40, color: Color(0xFF3A3A3C)),
              const SizedBox(height: 16),
              Text('Something went wrong',
                style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              Text(state.error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF636366), fontSize: 12)),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _performSearch,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF2C2C2E)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('Try Again',
                    style: TextStyle(color: Color(0xFFAEAEB2), fontSize: 13, fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (state.result != null) {
      final intent = state.result!;

      // Follow-up questions
      if (intent.intent == 'vehicle' &&
          intent.followupQuestions != null &&
          intent.followupQuestions!.isNotEmpty &&
          (intent.results == null || intent.results!.isEmpty)) {
        return _buildFollowUp(intent, theme);
      }

      // Vehicle list view
      if (intent.intent == 'vehicle' && intent.results != null && intent.results!.isNotEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${intent.results!.length} vehicles found',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  Text(intent.queryCleaned,
                    style: const TextStyle(color: Color(0xFF636366), fontSize: 12)),
                ],
              ),
            ),
            Expanded(child: VehicleListView(vehicles: intent.results!)),
          ],
        );
      }

      // Other intents
      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (intent.results != null && intent.results!.isNotEmpty) ...[
            Text('${intent.results!.length} results',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(intent.queryCleaned,
              style: const TextStyle(color: Color(0xFF636366), fontSize: 12)),
            const SizedBox(height: 16),
            ...intent.results!.map((p) => PlaceCard(
              place: p, userLat: _userLat, userLng: _userLng,
            )),
          ] else ...[
            const SizedBox(height: 80),
            const Center(
              child: Column(
                children: [
                  Icon(Icons.search_off_rounded, size: 40, color: Color(0xFF3A3A3C)),
                  SizedBox(height: 12),
                  Text('No results', style: TextStyle(color: Color(0xFF636366))),
                ],
              ),
            ),
          ],
        ],
      );
    }

    // Empty state
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_rounded, size: 40, color: Color(0xFF3A3A3C)),
          SizedBox(height: 12),
          Text('Search anything',
            style: TextStyle(color: Color(0xFF636366), fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildFollowUp(SearchIntentModel intent, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tell me more',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          ...intent.followupQuestions!.asMap().entries.map((e) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF2C2C2E)),
            ),
            child: Text(e.value,
              style: const TextStyle(color: Color(0xFFAEAEB2), fontSize: 13, height: 1.5)),
          )),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: [
              'Sedan under \$30K', 'SUV under \$40K',
              'Electric under \$50K', 'Luxury under \$100K',
            ].map((s) => GestureDetector(
              onTap: () { _searchController.text = s; _performSearch(); },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1E),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF2C2C2E)),
                ),
                child: Text(s,
                  style: const TextStyle(color: Color(0xFFAEAEB2), fontSize: 12)),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}
