import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/design_system.dart';

/// Back-office admin (Flutter Web) — squelette UI Jean.
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sand,
      body: Column(
        children: [
          NavyDecorHeader(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Row(
                  children: [
                    const EventBjLogo(onDark: true),
                    const Spacer(),
                    Text(
                      'Admin',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white,
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
                Text(
                  'Modération',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Valider les organisateurs et surveiller les litiges.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.muted,
                  ),
                ),
                const SizedBox(height: 20),
                const _AdminStat(
                  icon: TablerIcons.users,
                  label: 'Organisateurs à vérifier',
                  value: '3',
                ),
                const SizedBox(height: 12),
                const _AdminStat(
                  icon: TablerIcons.calendar_event,
                  label: 'Événements publiés',
                  value: '28',
                ),
                const SizedBox(height: 12),
                const _AdminStat(
                  icon: TablerIcons.alert_circle,
                  label: 'Litiges ouverts',
                  value: '1',
                ),
                const SizedBox(height: 24),
                AppCtaButton(
                  label: 'Ouvrir la file de validation',
                  icon: TablerIcons.checklist,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('File admin — à brancher Firestore'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminStat extends StatelessWidget {
  const _AdminStat({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return AppSurfaceCard(
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.sand,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: AppColors.navy),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.ink,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.navy,
            ),
          ),
        ],
      ),
    );
  }
}
