import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/search/presentation/search_screen.dart';
import 'package:go_router/go_router.dart';

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
    // We define the router here or import it
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => const SearchScreen(),
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
