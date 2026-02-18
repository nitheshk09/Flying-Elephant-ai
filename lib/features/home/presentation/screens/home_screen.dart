import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../chat/presentation/providers/chat_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: _RoundButton(
            icon: Icons.menu_rounded,
            onTap: () {},
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _RoundButton(
              icon: Icons.call_made_rounded, // or a custom arrow icon
              onTap: () {},
              iconColor: Colors.blueAccent.shade100,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          // Subtle radial glow behind logo
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.blueAccent.withOpacity(0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Header
                  Text(
                    'Ready to build, Alex?',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "What's on the roadmap today?",
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: const Color(0xFF6E6E73),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Let's create something grand",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF424245),
                      fontStyle: FontStyle.italic,
                    ),
                  ),

                  const Spacer(flex: 2),

                  // Center Logo
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF1C1C1E),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(30),
                    child: Image.asset(
                      'assets/FLYINGELEPHANTLOGO.png',
                      fit: BoxFit.contain,
                    ).animate().fadeIn(duration: 1000.ms).scale(delay: 200.ms),
                  ),

                  const Spacer(flex: 3),

                  // Action List
                  Column(
                    children: [
                      _ActionCard(
                        icon: Icons.directions_car_filled_outlined,
                        label: 'Find a Car',
                        onTap: () => _openVehicleChat(context, ref),
                      ),
                      const SizedBox(height: 12),
                      _ActionCard(
                        icon: Icons.assignment_turned_in_outlined,
                        label: 'Treatment Plan',
                        onTap: () {
                          ref.read(chatControllerProvider.notifier).sendMessage('Top endodontists in NYC');
                          context.push('/chat');
                        },
                      ),
                      const SizedBox(height: 12),
                      _ActionCard(
                        icon: Icons.near_me_outlined,
                        label: 'Products Near Me',
                        onTap: () {
                          ref.read(chatControllerProvider.notifier).sendMessage('MacBook Pro M4 price');
                          context.push('/chat');
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Bottom Search Bar
                  _BottomSearchBar(
                    onTap: () => context.push('/chat'),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openVehicleChat(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _VehicleChatSheet(
        onSubmit: (query) {
          Navigator.of(ctx).pop();
          ref.read(chatControllerProvider.notifier).sendMessage(query);
          context.push('/chat');
        },
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;

  const _RoundButton({required this.icon, required this.onTap, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFF1C1C1E),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor ?? Colors.white, size: 20),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionCard({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF0D0D0F),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF1C1C1E), width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.blueAccent.shade100, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF3A3A3C), size: 20),
          ],
        ),
      ),
    );
  }
}

class _BottomSearchBar extends StatelessWidget {
  final VoidCallback onTap;

  const _BottomSearchBar({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFF0D0D0F),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFF1C1C1E), width: 1),
        ),
        child: Row(
          children: [
            const Icon(Icons.enhance_photo_translate_rounded, color: Colors.blueAccent, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Ask anything...',
                style: TextStyle(
                  color: const Color(0xFF6E6E73),
                  fontSize: 16,
                ),
              ),
            ),
            const Icon(Icons.mic_none_rounded, color: Color(0xFF6E6E73), size: 22),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// VEHICLE CHAT SHEET — Conversational Flow
// ═══════════════════════════════════════════════════════════

class _ChatMessage {
  final String text;
  final bool isBot;
  final List<String>? options;
  final String? field;

  _ChatMessage({required this.text, this.isBot = true, this.options, this.field});
}

class _VehicleChatSheet extends StatefulWidget {
  final void Function(String query) onSubmit;
  const _VehicleChatSheet({required this.onSubmit});

  @override
  State<_VehicleChatSheet> createState() => _VehicleChatSheetState();
}

class _VehicleChatSheetState extends State<_VehicleChatSheet> {
  final ScrollController _scroll = ScrollController();
  final List<_ChatMessage> _messages = [];
  int _step = 0;
  bool _isTyping = false;

  // Collected answers
  String? _category;
  String? _brand;
  String? _bodyType;
  String? _seats;
  String? _budget;
  String? _fuel;
  String? _transmission;
  String? _usage;
  final List<String> _features = [];

  // Icon map for option chips
  static const Map<String, IconData> _optionIcons = {
    // Category
    'Car': Icons.directions_car_rounded,
    'SUV': Icons.directions_car_filled_rounded,
    'Truck': Icons.local_shipping_rounded,
    'Bike': Icons.two_wheeler_rounded,
    // Body type
    'Sedan': Icons.directions_car_filled_rounded,
    'Pickup': Icons.local_shipping_rounded,
    'Coupe': Icons.sports_motorsports_rounded,
    'Crossover': Icons.directions_car_rounded,
    'Minivan': Icons.airport_shuttle_rounded,
    'Convertible': Icons.directions_car_rounded,
    'No preference': Icons.all_inclusive_rounded,
    // Budget
    'Under \$20K': Icons.attach_money_rounded,
    '\$20K – \$30K': Icons.attach_money_rounded,
    '\$30K – \$40K': Icons.attach_money_rounded,
    '\$40K – \$60K': Icons.attach_money_rounded,
    '\$60K – \$80K': Icons.attach_money_rounded,
    '\$80K – \$120K': Icons.attach_money_rounded,
    '\$120K+': Icons.diamond_rounded,
    // Brand
    'Tesla': Icons.electric_bolt_rounded,
    'Toyota': Icons.directions_car_rounded,
    'BMW': Icons.sports_motorsports_rounded,
    'Mercedes': Icons.star_border_rounded,
    'Ford': Icons.local_shipping_rounded,
    'Honda': Icons.directions_car_rounded,
    'Any Brand': Icons.all_inclusive_rounded,
    // Seats
    '2 Seats': Icons.person_rounded,
    '4-5 Seats': Icons.people_rounded,
    '7+ Seats': Icons.groups_rounded,
    // Usage
    'Daily Commute': Icons.work_history_rounded,
    'Family Trips': Icons.family_restroom_rounded,
    'Performance/Track': Icons.speed_rounded,
    'Off-roading': Icons.terrain_rounded,
    // Features
    'Sunroof': Icons.wb_sunny_rounded,
    'Apple CarPlay': Icons.phone_iphone_rounded,
    'ADAS': Icons.shield_rounded,
    'Ventilated Seats': Icons.air_rounded,
    '360° Camera': Icons.camera_rounded,
    'Wireless Charging': Icons.charging_station_rounded,
    'Heated Seats': Icons.thermostat_rounded,
    'Alloy Wheels': Icons.circle_outlined,
    'LED Headlights': Icons.highlight_rounded,
    'Keyless Entry': Icons.key_rounded,
    'Done — search now': Icons.search_rounded,
  };

  final _steps = <Map<String, dynamic>>[
    {
      'text': "Hey there 👋\n\nI'm Flying Elephant Ai, your premium concierge. I'll help you find the perfect vehicle for New York. What are you looking for?",
      'field': 'category',
      'options': ['Car', 'SUV', 'Truck', 'Bike'],
    },
    {
      'text': 'Specific brand preference? (Select or skip)',
      'field': 'brand',
      'options': ['Tesla', 'Toyota', 'BMW', 'Mercedes', 'Ford', 'Honda', 'Any Brand'],
    },
    {
      'text': 'What body style do you prefer?',
      'field': 'body_type',
      'options': ['Sedan', 'SUV', 'Pickup', 'Coupe', 'Crossover', 'Minivan', 'Convertible', 'No preference'],
    },
    {
      'text': 'How many seats do you need?',
      'field': 'seats',
      'options': ['2 Seats', '4-5 Seats', '7+ Seats', 'No preference'],
    },
    {
      'text': "What's your project budget range?",
      'field': 'budget',
      'options': ['Under \$20K', '\$20K – \$30K', '\$30K – \$40K', '\$40K – \$60K', '\$60K – \$80K', '\$80K – \$120K', '\$120K+'],
    },
    {
      'text': 'Primary usage of the vehicle?',
      'field': 'usage',
      'options': ['Daily Commute', 'Family Trips', 'Performance/Track', 'Off-roading', 'No preference'],
    },
    {
      'text': 'Any fuel preference?',
      'field': 'fuel',
      'options': ['Gasoline', 'Diesel', 'Electric', 'Hybrid', 'No preference'],
    },
    {
      'text': 'Transmission?',
      'field': 'transmission',
      'options': ['Automatic', 'Manual', 'No preference'],
    },
    {
      'text': 'Any must-have features? Tap all that apply then hit Done.',
      'field': 'features',
      'options': ['Sunroof', 'Apple CarPlay', 'ADAS', 'Ventilated Seats', '360° Camera', 'Wireless Charging', 'Heated Seats', 'Alloy Wheels', 'LED Headlights', 'Keyless Entry', 'Done — search now'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _sendNextBotMessage();
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _sendNextBotMessage() async {
    if (_step >= _steps.length) {
      _submit();
      return;
    }

    setState(() => _isTyping = true);
    await Future.delayed(const Duration(milliseconds: 600));

    final step = _steps[_step];
    setState(() {
      _isTyping = false;
      _messages.add(_ChatMessage(
        text: step['text'],
        isBot: true,
        options: List<String>.from(step['options']),
        field: step['field'],
      ));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(_scroll.position.maxScrollExtent + 100,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  void _onOptionTap(String option, String? field) {
    if (field == 'features') {
      if (option == 'Done — search now') {
        setState(() {
          _messages.add(_ChatMessage(
            text: _features.isEmpty ? 'No special features needed' : _features.join(', '),
            isBot: false,
          ));
        });
        _step++;
        _sendNextBotMessage();
        return;
      }
      setState(() {
        if (_features.contains(option)) {
          _features.remove(option);
        } else {
          _features.add(option);
        }
      });
      return;
    }

    // Record answer
    switch (field) {
      case 'category': _category = option; break;
      case 'brand': _brand = option == 'Any Brand' ? null : option; break;
      case 'body_type': _bodyType = option == 'No preference' ? null : option; break;
      case 'seats': _seats = option == 'No preference' ? null : option; break;
      case 'budget': _budget = option; break;
      case 'usage': _usage = option == 'No preference' ? null : option; break;
      case 'fuel': _fuel = option == 'No preference' ? null : option; break;
      case 'transmission': _transmission = option == 'No preference' ? null : option; break;
    }

    setState(() {
      _messages.add(_ChatMessage(text: option, isBot: false));
    });
    _step++;
    _sendNextBotMessage();
  }

  void _submit() async {
    setState(() => _isTyping = true);
    await Future.delayed(const Duration(milliseconds: 400));

    setState(() {
      _isTyping = false;
      _messages.add(_ChatMessage(
        text: 'Great choices! Searching for your perfect vehicle now...',
        isBot: true,
      ));
    });

    await Future.delayed(const Duration(milliseconds: 800));

    final parts = <String>[];
    if (_brand != null) parts.add(_brand!);
    if (_category != null) parts.add(_category!);
    if (_bodyType != null) parts.add(_bodyType!);
    if (_seats != null) parts.add(_seats!);
    if (_budget != null) parts.add(_budget!);
    if (_usage != null) parts.add('for $_usage');
    if (_fuel != null) parts.add(_fuel!);
    if (_transmission != null) parts.add(_transmission!);
    if (_features.isNotEmpty) parts.add('with ${_features.join(", ")}');
    parts.add('in New York');

    widget.onSubmit(parts.join(' '));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPad = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFF0A0A0A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          const SizedBox(height: 10),
          Container(width: 36, height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF3A3A3C),
              borderRadius: BorderRadius.circular(2),
            )),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C1C1E),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.directions_car_rounded,
                      size: 18, color: Color(0xFFF5F5F7)),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Vehicle Finder',
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                    Text('Powered by AI',
                      style: theme.textTheme.labelSmall?.copyWith(color: const Color(0xFF636366))),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close_rounded, color: Color(0xFF636366), size: 22),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (ctx, i) {
                if (i == _messages.length && _isTyping) {
                  return _buildTypingIndicator();
                }
                final msg = _messages[i];
                if (msg.isBot) {
                  return _buildBotBubble(msg, theme);
                }
                return _buildUserBubble(msg, theme);
              },
            ),
          ),

          // Bottom padding
          SizedBox(height: bottomPad > 0 ? bottomPad : 20),
        ],
      ),
    );
  }

  Widget _buildBotBubble(_ChatMessage msg, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Message
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: Color(0xFF1C1C1E),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: Text(msg.text,
              style: const TextStyle(color: Color(0xFFF5F5F7), fontSize: 14, height: 1.5)),
          ),

          // Options
          if (msg.options != null) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: msg.options!.map((opt) {
                final isFeature = msg.field == 'features' && opt != 'Done — search now';
                final isSelected = isFeature && _features.contains(opt);
                final isDone = opt == 'Done — search now';

                return GestureDetector(
                  onTap: () => _onOptionTap(opt, msg.field),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: EdgeInsets.symmetric(
                      horizontal: isDone ? 20 : 14,
                      vertical: isDone ? 10 : 8,
                    ),
                    decoration: BoxDecoration(
                      color: isDone
                          ? const Color(0xFFF5F5F7)
                          : isSelected
                            ? const Color(0xFF3A3A3C)
                            : const Color(0xFF1C1C1E),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDone
                            ? const Color(0xFFF5F5F7)
                            : isSelected
                              ? const Color(0xFF636366)
                              : const Color(0xFF2C2C2E),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isSelected)
                          const Padding(
                            padding: EdgeInsets.only(right: 4),
                            child: Icon(Icons.check_rounded, size: 14, color: Color(0xFFF5F5F7)),
                          )
                        else if (_optionIcons.containsKey(opt))
                          Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Icon(
                              _optionIcons[opt],
                              size: 15,
                              color: isDone ? const Color(0xFF0A0A0A) : const Color(0xFF636366),
                            ),
                          ),
                        Text(opt,
                          style: TextStyle(
                            color: isDone ? const Color(0xFF0A0A0A) : const Color(0xFFAEAEB2),
                            fontSize: 13,
                            fontWeight: isDone || isSelected ? FontWeight.w600 : FontWeight.w400,
                          )),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUserBubble(_ChatMessage msg, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.65,
          ),
          padding: const EdgeInsets.all(14),
          decoration: const BoxDecoration(
            color: Color(0xFFF5F5F7),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(4),
            ),
          ),
          child: Text(msg.text,
            style: const TextStyle(color: Color(0xFF0A0A0A), fontSize: 14, fontWeight: FontWeight.w500)),
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF1C1C1E),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(3, (i) => _TypingDot(delay: i * 200)),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypingDot extends StatefulWidget {
  final int delay;
  const _TypingDot({required this.delay});

  @override
  State<_TypingDot> createState() => _TypingDotState();
}

class _TypingDotState extends State<_TypingDot> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _anim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 3),
        width: 6, height: 6,
        decoration: BoxDecoration(
          color: Color.lerp(const Color(0xFF3A3A3C), const Color(0xFF8E8E93), _anim.value),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
