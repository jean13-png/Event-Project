import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';

class EventBjApp extends StatelessWidget {
  const EventBjApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'EventBJ',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}

/// Point d'entrée wrappé Riverpod.
class EventBjRoot extends StatelessWidget {
  const EventBjRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
      child: EventBjApp(),
    );
  }
}
