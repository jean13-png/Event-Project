import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_colors.dart';
import 'features/home/presentation/screens/home_screen.dart';

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

    return MaterialApp(
      title: 'EventBJ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        scaffoldBackgroundColor: AppColors.sand,
        colorScheme: const ColorScheme.light(
          primary: AppColors.navy,
          secondary: AppColors.orange,
          surface: AppColors.white,
          error: Colors.red,
          onPrimary: AppColors.white,
          onSecondary: AppColors.white,
          onSurface: AppColors.ink,
          onError: AppColors.white,
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.ink),
          headlineMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.ink, letterSpacing: -0.3),
          bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.ink, height: 1.5),
          bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.muted, height: 1.5),
          labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w400, color: AppColors.muted),
        ),
        useMaterial3: false,
      ),
      home: const HomeScreen(),
    );
  }
}
