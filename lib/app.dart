import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/navigation/app_router.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/presentation/providers/onboarding_providers.dart';
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

class MyMoodRoot extends StatefulWidget {
  const MyMoodRoot({super.key});

  @override
  State<MyMoodRoot> createState() => _MyMoodRootState();
}

class _MyMoodRootState extends State<MyMoodRoot> {
  var _onboardingComplete = false;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Consumer(
        builder: (context, ref, _) {
          if (_onboardingComplete) {
            return const MyMoodApp();
          }

          final onboardingAsync = ref.watch(onboardingCompletedProvider);

          return onboardingAsync.when(
            loading: () => MaterialApp(
              home: Scaffold(
                backgroundColor: AppColors.sand,
                body: const Center(
                  child: CircularProgressIndicator(color: AppColors.navy),
                ),
              ),
            ),
            error: (_, __) => const MyMoodApp(),
            data: (completed) {
              if (completed) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) {
                    setState(() => _onboardingComplete = true);
                  }
                });
                return MaterialApp(
                  home: Scaffold(
                    backgroundColor: AppColors.sand,
                    body: const Center(
                      child: CircularProgressIndicator(color: AppColors.navy),
                    ),
                  ),
                );
              }
              return MaterialApp(
                title: 'MyMood',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light,
                home: OnboardingScreen(
                  onComplete: () {
                    setState(() => _onboardingComplete = true);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
