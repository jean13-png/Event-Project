import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';

/// Placeholder Profil — module Épiphane (lien vers auth/wallet Jean).
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sand,
      appBar: AppBar(title: const Text('Profil')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Module Épiphane — paramètres & favoris',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 24),
          ListTile(
            tileColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            leading: const Icon(TablerIcons.login, color: AppColors.navy),
            title: const Text('Connexion'),
            subtitle: const Text('OTP / Google — Jean'),
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
