import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../providers/chat_providers.dart';
import '../../data/models/chat_message.dart';
import '../../../result/presentation/vehicle_card.dart';
import '../../../result/presentation/place_card.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    await _speechToText.initialize();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      ref.read(chatControllerProvider.notifier).sendMessage("What's in this image?", imagePath: image.path);
    }
  }

  Future<void> _handleCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      ref.read(chatControllerProvider.notifier).sendMessage("What's in this photo?", imagePath: image.path);
    }
  }

  void _toggleListening() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speechToText.listen(onResult: (result) {
          if (result.finalResult) {
            setState(() {
              _isListening = false;
              _textController.text = result.recognizedWords;
            });
            _handleSubmit();
          }
        });
      }
    } else {
      setState(() => _isListening = false);
      _speechToText.stop();
    }
  }

  void _handleSubmit() {
    final text = _textController.text.trim();
    if (text.isNotEmpty) {
      ref.read(chatControllerProvider.notifier).sendMessage(text);
      _textController.clear();
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatControllerProvider);
    final theme = Theme.of(context);

    // Initial message if empty
    if (chatState.messages.isEmpty) {
      return _buildEmptyState();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: chatState.messages.length + (chatState.isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == chatState.messages.length) {
                  return _buildTypingIndicator();
                }
                final message = chatState.messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _buildAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.auto_awesome_rounded, size: 64, color: Color(0xFF1C1C1E)),
            const SizedBox(height: 24),
            Text(
              "How can I help you today?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 32),
            _buildQuickActions(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: _buildInputArea(),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        _QuickActionChip(
          label: "Find a Luxury Car",
          icon: Icons.directions_car_rounded,
          onTap: () => _textController.text = "Show me luxury SUVs in NYC",
        ),
        _QuickActionChip(
          label: "Treatment Center",
          icon: Icons.local_hospital_rounded,
          onTap: () => _textController.text = "Best eye hospitals in Hyderabad",
        ),
        _QuickActionChip(
          label: "Premium Courses",
          icon: Icons.school_rounded,
          onTap: () => _textController.text = "Data Science courses at IIT",
        ),
      ],
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close_rounded, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
            Container(
                width: 24, height: 24,
                decoration: BoxDecoration(
                    color: Color(0xFF1C1C1E),
                    shape: BoxShape.circle
                ),
                child: Icon(Icons.bolt, size: 14, color: Colors.blueAccent)
            ),
            SizedBox(width: 8),
            Text("Flying Elephant AI", style: TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF8E8E93)),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    bool isUser = message.type == MessageType.user;

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (message.imagePath != null)
             _buildImageHeader(message.imagePath!),
          
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isUser ? const Color(0xFF1C1C1E) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.5,
                    fontWeight: isUser ? FontWeight.w400 : FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
          
          if (message.searchResult != null)
            _buildSearchResults(message.searchResult!),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildImageHeader(String path) {
    return Container(
        margin: EdgeInsets.only(bottom: 8),
        width: 200, height: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(image: FileImage(File(path)), fit: BoxFit.cover)
        ),
    );
  }

  Widget _buildSearchResults(dynamic result) {
    if (result.results == null || result.results.isEmpty) return SizedBox.shrink();

    if (result.intent == 'vehicle') {
        return Container(
            height: 500,
            margin: EdgeInsets.only(top: 16),
            child: VehicleListView(vehicles: result.results),
        );
    }

    return Container(
        margin: EdgeInsets.only(top: 16),
        child: Column(
            children: result.results.map<Widget>((p) => PlaceCard(place: p)).toList(),
        ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: List.generate(3, (i) => 
                Container(
                  width: 6, height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: const BoxDecoration(color: Color(0xFF8E8E93), shape: BoxShape.circle),
                ).animate(onPlay: (c) => c.repeat()).scale(duration: 400.ms, delay: (i * 100).ms, begin: Offset(0.8, 0.8), end: Offset(1.2, 1.2)).fadeOut(duration: 400.ms)
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: Color(0xFF1C1C1E), width: 0.5)),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFF2C2C2E)),
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.camera_alt_rounded, color: Color(0xFF8E8E93), size: 22),
              onPressed: _handleCamera,
            ),
            IconButton(
              icon: const Icon(Icons.image_rounded, color: Color(0xFF8E8E93), size: 22),
              onPressed: _handleImage,
            ),
            Expanded(
              child: TextField(
                controller: _textController,
                maxLines: 5,
                minLines: 1,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                decoration: const InputDecoration(
                  hintText: 'Message Flying Elephant...',
                  hintStyle: TextStyle(color: Color(0xFF636366)),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                ),
                onSubmitted: (_) => _handleSubmit(),
              ),
            ),
            IconButton(
              icon: Icon(
                _isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                color: _isListening ? Colors.blueAccent : const Color(0xFF8E8E93),
                size: 22,
              ),
              onPressed: _toggleListening,
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: _handleSubmit,
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_upward_rounded, color: Colors.black, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _QuickActionChip({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF2C2C2E)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFF8E8E93), size: 16),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Color(0xFFAEAEB2), fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
