import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/design_system.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class RoleSelectionScreen extends ConsumerWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.sand,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MyMoodLogo(onDark: false),
              const SizedBox(height: 24),
              Text(
                'Bienvenue sur MyMood',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choisis ton profil pour continuer.',
                style: GoogleFonts.inter(fontSize: 14, color: AppColors.muted),
              ),
              const SizedBox(height: 28),
              _RoleCard(
                icon: TablerIcons.ticket,
                label: 'Acheteur',
                description: 'Découvrir et participer à des événements.',
                onTap: () async {
                  await ref.read(authServiceProvider).setUserType('buyer');
                  if (context.mounted) context.go(AppRoutes.home);
                },
              ),
              const SizedBox(height: 12),
              _RoleCard(
                icon: TablerIcons.calendar_event,
                label: 'Organisateur',
                description: 'Créer, publier et gérer tes événements.',
                onTap: () async {
                  await ref.read(authServiceProvider).setUserType('organizer');
                  if (context.mounted) context.go(AppRoutes.home);
                },
              ),
              const Spacer(),
              Text(
                'Tu pourras modifier ton rôle plus tard dans les paramètres.',
                style: GoogleFonts.inter(fontSize: 12, color: AppColors.muted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.icon,
    required this.label,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.sand,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: AppColors.navy),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.muted),
                ),
              ],
            ),
          ),
          const Icon(TablerIcons.chevron_right, size: 18, color: AppColors.muted),
        ],
      ),
    );
  }
}
