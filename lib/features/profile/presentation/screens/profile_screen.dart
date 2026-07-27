import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/design_system.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

/// Profil — liens vers modules Jean (auth, wallet, notifs, admin).
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authStateProvider);
    final user = authAsync.value;

    return Scaffold(
      backgroundColor: AppColors.sand,
      body: Column(
        children: [
          NavyDecorHeader(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 12, 20),
                child: Row(
                  children: [
                    const MyMoodLogo(onDark: true),
                    const Spacer(),
                    IconButton(
                      tooltip: 'Notifications',
                      onPressed: () => context.push(AppRoutes.notifications),
                      icon: const Icon(
                        TablerIcons.bell,
                        color: AppColors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              children: [
                if (user != null) ...[
                  AppSurfaceCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Connecté',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.phoneNumber ?? user.email ?? user.uid,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ProfileTile(
                    icon: TablerIcons.logout,
                    title: 'Se déconnecter',
                    onTap: () async {
                      await ref.read(authControllerProvider.notifier).signOut();
                    },
                  ),
                ] else
                  _ProfileTile(
                    icon: TablerIcons.login,
                    title: 'Connexion',
                    subtitle: 'OTP SMS ou Google',
                    onTap: () => context.push(AppRoutes.login),
                  ),
                const SizedBox(height: 12),
                _ProfileTile(
                  icon: TablerIcons.wallet,
                  title: 'Portefeuille',
                  subtitle: 'Solde organisateur',
                  onTap: () => context.push(AppRoutes.wallet),
                ),
                const SizedBox(height: 12),
                _ProfileTile(
                  icon: TablerIcons.bell,
                  title: 'Notifications',
                  onTap: () => context.push(AppRoutes.notifications),
                ),
                const SizedBox(height: 12),
                _ProfileTile(
                  icon: TablerIcons.calendar_event,
                  title: 'Demo page événement',
                  subtitle: '/events/demo-concert',
                  onTap: () => context.push('/events/demo-concert'),
                ),
                const SizedBox(height: 12),
                _ProfileTile(
                  icon: TablerIcons.shield,
                  title: 'Admin',
                  subtitle: 'Back-office',
                  onTap: () => context.push(AppRoutes.admin),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: AppColors.navy, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.muted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Icon(TablerIcons.chevron_right, size: 18, color: AppColors.muted),
        ],
      ),
    );
  }
}
