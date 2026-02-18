import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../search/presentation/providers/search_providers.dart';
import '../../data/models/chat_message.dart';

class ChatState {
  final List<ChatMessage> messages;
  final bool isTyping;

  ChatState({
    required this.messages,
    this.isTyping = false,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isTyping,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}

class ChatController extends Notifier<ChatState> {
  final _uuid = const Uuid();

  @override
  ChatState build() {
    return ChatState(messages: []);
  }

  Future<void> sendMessage(String text, {String? imagePath}) async {
    if (text.trim().isEmpty && imagePath == null) return;

    final userMsg = ChatMessage(
      id: _uuid.v4(),
      text: text,
      type: MessageType.user,
      timestamp: DateTime.now(),
      imagePath: imagePath,
    );

    state = state.copyWith(
      messages: [...state.messages, userMsg],
      isTyping: true,
    );

    try {
      final repository = ref.read(searchRepositoryProvider);
      final intent = await repository.getIntent(text);

      final aiMsg = ChatMessage(
        id: _uuid.v4(),
        text: _getInitialResponse(intent.intent),
        type: MessageType.ai,
        timestamp: DateTime.now(),
        searchResult: intent,
      );

      state = state.copyWith(
        messages: [...state.messages, aiMsg],
        isTyping: false,
      );
    } catch (e) {
      final errorMsg = ChatMessage(
        id: _uuid.v4(),
        text: "I'm sorry, I encountered an error: ${e.toString()}",
        type: MessageType.ai,
        timestamp: DateTime.now(),
      );
      state = state.copyWith(
        messages: [...state.messages, errorMsg],
        isTyping: false,
      );
    }
  }

  String _getInitialResponse(String intent) {
    switch (intent) {
      case 'vehicle':
        return "I've analyzed your request and found some exceptional vehicles in Northern India that match your profile. Here's what I recommend:";
      case 'treatment':
        return "Hyderabad has world-class healthcare. Based on your needs, I've curated a list of top-tier facilities:";
      case 'course':
        return "Education is a priority. Here are the most prestigious institutes in Hyderabad matching your interest:";
      case 'product':
        return "I've located the best retailers in Hyderabad where you can find this. Check these options:";
      case 'service':
        return "Expert service is just around the corner. I've found these highly-rated providers for you:";
      default:
        return "I've looked into that for you. Here's what I found in Hyderabad:";
    }
  }

  void clearChat() {
    state = ChatState(messages: []);
  }
}

final chatControllerProvider = NotifierProvider<ChatController, ChatState>(ChatController.new);
