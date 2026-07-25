import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';

class EventBjApp extends ConsumerWidget {
  const EventBjApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF0D3B6E),
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFFF5F4EF),
      ),
    );

    return MaterialApp.router(
      title: 'EventBJ',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}

class EventBjRoot extends StatelessWidget {
  const EventBjRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
      child: EventBjApp(),
    );
  }
}
