import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';

/// Connexion OTP SMS / Google — responsabilité Jean.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sand,
      appBar: AppBar(
        title: const Text('Connexion'),
        leading: IconButton(
          icon: const Icon(TablerIcons.arrow_left, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'EventBJ',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    color: AppColors.navy,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Connecte-toi avec ton numéro ou Google.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 32),
            TextField(
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: 'Numéro (ex. +229…)',
                prefixIcon: Icon(TablerIcons.phone, size: 18),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('OTP SMS — à brancher sur Firebase Auth'),
                  ),
                );
              },
              child: const Text('Recevoir le code SMS'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Google Sign-In — à brancher'),
                  ),
                );
              },
              icon: const Icon(TablerIcons.brand_google, size: 18),
              label: const Text('Continuer avec Google'),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => context.go(AppRoutes.home),
              child: Text(
                'Continuer sans compte',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.navy,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
