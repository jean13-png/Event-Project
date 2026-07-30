import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/navigation/app_router.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/presentation/providers/onboarding_providers.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';

class EventBJApp extends ConsumerWidget {
  const EventBJApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.navy,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.sand,
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

class EventBJRoot extends StatefulWidget {
  const EventBJRoot({super.key});

  @override
  State<EventBJRoot> createState() => _EventBJRootState();
}

class _EventBJRootState extends State<EventBJRoot> {
  var _onboardingComplete = false;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: Consumer(
        builder: (context, ref, _) {
          if (_onboardingComplete) {
            return const EventBJApp();
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
            error: (_, __) => const EventBJApp(),
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
                title: 'EventBJ',
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
