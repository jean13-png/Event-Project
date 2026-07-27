import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/design_system.dart';
import '../providers/wallet_providers.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletAsync = ref.watch(walletProvider);
    final transactionsAsync = ref.watch(walletTransactionsProvider);

    return Scaffold(
      backgroundColor: AppColors.sand,
      appBar: AppBar(
        title: const Text('Portefeuille'),
        leading: IconButton(
          icon: const Icon(TablerIcons.arrow_left, size: 20),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(AppRoutes.profile);
            }
          },
        ),
      ),
      body: walletAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.navy)),
        error: (e, _) => Center(child: Text('Erreur: $e', style: const TextStyle(color: AppColors.muted))),
        data: (wallet) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: NavyDecorHeader(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(TablerIcons.wallet, color: AppColors.white, size: 20),
                            const SizedBox(width: 8),
                            Text('Solde disponible', style: GoogleFonts.inter(fontSize: 12, color: AppColors.white.withValues(alpha: 0.8))),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text('${wallet.balance} F', style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.white)),
                        const SizedBox(height: 8),
                        Text('En attente : ${wallet.pendingBalance} F', style: GoogleFonts.inter(fontSize: 12, color: AppColors.white.withValues(alpha: 0.7))),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AppCtaButton(label: 'Demander un retrait', icon: TablerIcons.cash, onPressed: () => context.push(AppRoutes.withdraw)),
              const SizedBox(height: 26),
              Text('Historique', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: -0.3, color: AppColors.ink)),
              const SizedBox(height: 12),
              transactionsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(color: AppColors.navy)),
                error: (e, _) => Center(child: Text('Erreur: $e', style: const TextStyle(color: AppColors.muted))),
                data: (transactions) {
                  if (transactions.isEmpty) {
                    return const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Text('Aucune transaction', style: TextStyle(color: AppColors.muted)));
                  }
                  final items = <Widget>[];
                  for (final tx in transactions) {
                    items.add(
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AppSurfaceCard(
                          child: Row(
                            children: [
                              Container(width: 40, height: 40, decoration: BoxDecoration(color: AppColors.sand, borderRadius: BorderRadius.circular(12)), child: Icon(tx.isCredit ? TablerIcons.arrow_down_left : TablerIcons.arrow_up_right, size: 18, color: tx.isCredit ? AppColors.green : AppColors.navy)),
                              const SizedBox(width: 12),
                              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(tx.title.isEmpty ? (tx.isCredit ? 'Crédit' : 'Débit') : tx.title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink)),
                                const SizedBox(height: 2),
                                Text('${tx.createdAt.day}/${tx.createdAt.month}/${tx.createdAt.year}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.muted)),
                              ])),
                              Text('${tx.isCredit ? '+' : '-'} ${tx.amount} F', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: tx.isCredit ? AppColors.green : AppColors.orange)),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return Column(children: items);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
