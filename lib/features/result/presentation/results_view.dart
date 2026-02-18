import 'package:flutter/material.dart';
import 'place_card.dart';
import '../../search/data/models/search_intent_model.dart';

class ResultsView extends StatelessWidget {
  final List<PlaceResult> results;
  final String title;

  const ResultsView({super.key, required this.results, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: results.length,
          itemBuilder: (context, index) {
            return PlaceCard(place: results[index]);
          },
        ),
      ],
    );
  }
}
