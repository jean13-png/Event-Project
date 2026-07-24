import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

/// Placeholder Profil — module Épiphane (lien vers auth/wallet Jean).
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authStateProvider);
    final user = authAsync.value;

    return Scaffold(
      backgroundColor: AppColors.sand,
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          if (user != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppColors.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Connecté',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.phoneNumber ?? user.email ?? user.uid,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            ListTile(
              tileColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              leading: const Icon(TablerIcons.logout, color: AppColors.navy),
              title: const Text('Se déconnecter'),
              onTap: () async {
                await ref.read(authControllerProvider.notifier).signOut();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Déconnecté.')),
                  );
                }
              },
            ),
          ] else
            ListTile(
              tileColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              leading: const Icon(TablerIcons.login, color: AppColors.navy),
              title: const Text('Connexion'),
              subtitle: const Text('OTP SMS — Jean'),
              onTap: () => context.push(AppRoutes.login),
            ),
          const SizedBox(height: 12),
          ListTile(
            tileColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            leading: const Icon(TablerIcons.wallet, color: AppColors.navy),
            title: const Text('Portefeuille'),
            subtitle: const Text('Organisateur — Jean'),
            onTap: () => context.push(AppRoutes.wallet),
          ),
          const SizedBox(height: 12),
          ListTile(
            tileColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            leading: const Icon(
              TablerIcons.calendar_event,
              color: AppColors.navy,
            ),
            title: const Text('Demo page événement'),
            subtitle: const Text('/events/demo-concert'),
            onTap: () => context.push('/events/demo-concert'),
          ),
        ],
      ),
    );
  }
}
