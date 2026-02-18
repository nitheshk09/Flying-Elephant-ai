import '../../../search/data/models/search_intent_model.dart';

enum MessageType { user, ai, system }

class ChatMessage {
  final String id;
  final String text;
  final MessageType type;
  final DateTime timestamp;
  final SearchIntentModel? searchResult;
  final String? imagePath;

  ChatMessage({
    required this.id,
    required this.text,
    required this.type,
    required this.timestamp,
    this.searchResult,
    this.imagePath,
  });

  ChatMessage copyWith({
    String? text,
    SearchIntentModel? searchResult,
  }) {
    return ChatMessage(
      id: id,
      text: text ?? this.text,
      type: type,
      timestamp: timestamp,
      searchResult: searchResult ?? this.searchResult,
      imagePath: imagePath,
    );
  }
}
