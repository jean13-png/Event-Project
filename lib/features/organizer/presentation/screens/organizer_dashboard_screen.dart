import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/design_system.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../wallet/presentation/providers/wallet_providers.dart';
import '../../../home/presentation/providers/home_providers.dart';

class OrganizerDashboardScreen extends ConsumerWidget {
  const OrganizerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authStateProvider);
    final walletAsync = ref.watch(walletProvider);

    return userAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.navy)),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Erreur: $e', style: const TextStyle(color: AppColors.muted))),
      ),
      data: (user) {
        if (user == null) {
          return Scaffold(
            backgroundColor: AppColors.sand,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(TablerIcons.lock, size: 32, color: AppColors.navy),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Oups, vous n\'êtes pas connecté',
                      style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.ink),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Connecte-toi pour accéder à ton espace organisateur.',
                      style: GoogleFonts.inter(fontSize: 14, color: AppColors.muted),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    AppCtaButton(
                      label: 'Se connecter',
                      icon: TablerIcons.login,
                      onPressed: () => context.push(AppRoutes.login),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final organizerId = user.uid;
        final statsAsync = ref.watch(organizerStatsProvider(organizerId));

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
                        const MyMoodLogo(onDark: true),
                        const Spacer(),
                        IconButton(
                          tooltip: 'Notifications',
                          onPressed: () => context.push(AppRoutes.notifications),
                          icon: const Icon(TablerIcons.bell, color: AppColors.white, size: 20),
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
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tableau de bord',
                                style: GoogleFonts.inter(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.ink,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Vue organisateur',
                                style: GoogleFonts.inter(fontSize: 13, color: AppColors.muted),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: AppColors.cardShadow,
                          ),
                          child: Row(
                            children: [
                              const Icon(TablerIcons.wallet, size: 16, color: AppColors.navy),
                              const SizedBox(width: 8),
                              walletAsync.when(
                                loading: () => const SizedBox(width: 60, height: 12, child: LinearProgressIndicator(color: AppColors.navy, minHeight: 12)),
                                error: (_, __) => Text('-- F', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink)),
                                data: (wallet) => Text(
                                  '${wallet.balance} F',
                                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    statsAsync.when(
                      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.navy)),
                      error: (e, _) => Center(child: Text('Erreur: $e', style: const TextStyle(color: AppColors.muted))),
                      data: (stats) {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Expanded(child: _StatCard(icon: TablerIcons.calendar_event, label: 'Événements', value: '${stats['totalEvents']}')),
                                const SizedBox(width: 12),
                                Expanded(child: _StatCard(icon: TablerIcons.ticket, label: 'Billets', value: '${stats['totalTicketsSold']}')),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _StatCard(icon: TablerIcons.wallet, label: 'Recettes', value: '${(stats['totalRevenue'] as double).toInt()} F', fullWidth: true),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: AppCtaButton(
                                    label: 'Créer un événement',
                                    icon: TablerIcons.plus,
                                    onPressed: () => context.push(AppRoutes.newEvent),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: AppSecondaryButton(
                                    label: 'Mes événements',
                                    icon: TablerIcons.list,
                                    onPressed: () => context.push(AppRoutes.organizerEvents),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            AppSecondaryButton(
                              label: 'Partager le lien de paiement',
                              icon: TablerIcons.share,
                              onPressed: () {
                                final eventLink = 'https://mymood.page.link/events/';
                                SharePlus.instance.share(ShareParams(text: '$eventLink — Réserve ta place maintenant !'));
                              },
                            ),
                            const SizedBox(height: 20),
                            Text('Ventes récentes', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.ink)),
                            const SizedBox(height: 12),
                            ..._buildRecentSales(context, stats['recentSales'] as List<Map<String, dynamic>>? ?? const []),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildRecentSales(BuildContext context, List<Map<String, dynamic>> sales) {
    if (sales.isEmpty) return [const Text('Aucune vente pour le moment.', style: TextStyle(color: AppColors.muted))];
    return sales.map((s) {
      final amount = (s['price'] is double ? s['price'] : (s['price'] as num?)?.toDouble() ?? 0.0) * ((s['quantity'] as int?) ?? 1);
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: AppSurfaceCard(
          child: Row(
            children: [
              Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.sand, borderRadius: BorderRadius.circular(12)), child: const Icon(TablerIcons.receipt, size: 18, color: AppColors.navy)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s['buyerName'] ?? 'Acheteur', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink)),
                const SizedBox(height: 2),
                Text('${s['type']} · ${s['eventId']}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.muted)),
              ])),
              Text('${amount.toInt()} F', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.green)),
            ],
          ),
        ),
      );
    }).toList();
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.icon, required this.label, required this.value, this.fullWidth = false});

  final IconData icon;
  final String label;
  final String value;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        children: [
          Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.sand, borderRadius: BorderRadius.circular(12)), child: Icon(icon, size: 20, color: AppColors.navy)),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: GoogleFonts.inter(fontSize: 14, color: AppColors.muted))),
          Text(value, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.navy)),
        ],
      ),
    );
  }
}
