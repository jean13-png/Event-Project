import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/navigation/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';

class MyMoodApp extends ConsumerWidget {
  const MyMoodApp({super.key});

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
      title: 'MyMood',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: appRouter,
    );
  }
}

class MyMoodRoot extends ConsumerWidget {
  const MyMoodRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingAsync = ref.watch(onboardingCompletedProvider);

    return onboardingAsync.when(
      loading: () => const MaterialApp(
        home: Scaffold(
          backgroundColor: AppColors.sand,
          body: Center(
            child: CircularProgressIndicator(color: AppColors.navy),
          ),
        ),
      ),
      error: (_, __) => const MyMoodApp(),
      data: (completed) {
        if (!completed) {
          return const OnboardingScreen();
        }
        return const ProviderScope(
          child: MyMoodApp(),
        );
      },
    );
  }
}
