import 'dart:async';
import 'package:flutter/material.dart';

class SearchLoadingView extends StatefulWidget {
  const SearchLoadingView({super.key});

  @override
  State<SearchLoadingView> createState() => _SearchLoadingViewState();
}

class _SearchLoadingViewState extends State<SearchLoadingView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _taglineIndex = 0;
  int _brandIndex = 0;
  Timer? _taglineTimer;
  Timer? _brandTimer;

  final List<String> _taglines = [
    'Analyzing your requirements...',
    'Curating the finest automotive options...',
    'Verifying real-time prices in New York...',
    'Comparing safety & performance specs...',
    'Finding authorized dealerships nearby...',
    'Scanning for latest 2025 inventory...',
  ];

  final List<String> _brands = [
    'TESLA', 'MERCEDES-BENZ', 'BMW', 'PORSCHE', 'AUDI',
    'TATA', 'MAHINDRA', 'TOYOTA', 'FERRARI', 'LAMBORGHINI',
    'HYUNDAI', 'KIA', 'LAND ROVER', 'VOLVO', 'BENTLEY'
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _taglineTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() => _taglineIndex = (_taglineIndex + 1) % _taglines.length);
      }
    });

    _brandTimer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (mounted) {
        setState(() => _brandIndex = (_brandIndex + 1) % _brands.length);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _taglineTimer?.cancel();
    _brandTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animating Brand Logo/Name
          SizedBox(
            height: 60,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) => FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.2),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ),
              child: Text(
                _brands[_brandIndex],
                key: ValueKey(_brands[_brandIndex]),
                style: const TextStyle(
                  color: Color(0xFFF5F5F7),
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 4,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 40),

          // Central Loading Element
          Stack(
            alignment: Alignment.center,
            children: [
              _buildPulsingCircle(100, 0.2),
              _buildPulsingCircle(140, 0.1),
              const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFFF5F5F7),
                ),
              ),
            ],
          ),

          const SizedBox(height: 60),

          // Animating Tagline
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 800),
              child: Text(
                _taglines[_taglineIndex],
                key: ValueKey(_taglines[_taglineIndex]),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF8E8E93),
                  fontSize: 14,
                  height: 1.5,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPulsingCircle(double size, double opacity) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: size * (1 + _controller.value * 0.1),
          height: size * (1 + _controller.value * 0.1),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFF5F5F7).withOpacity(opacity * (1 - _controller.value * 0.5)),
              width: 1,
            ),
          ),
        );
      },
    );
  }
}
