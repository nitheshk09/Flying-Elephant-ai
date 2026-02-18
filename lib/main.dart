import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/chat/presentation/screens/chat_screen.dart';
import 'package:go_router/go_router.dart';

import 'features/home/presentation/screens/splash_screen.dart';

// Update theme import
import 'core/theme/app_theme.dart';

void main() {
  runApp(
    ProviderScope(
      child: const FlyingElephantAIApp(),
    ),
  );
}

class FlyingElephantAIApp extends ConsumerWidget {
  const FlyingElephantAIApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/chat',
          builder: (context, state) => const ChatScreen(),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Flying Elephant Ai',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: router,
    );
  }
}
