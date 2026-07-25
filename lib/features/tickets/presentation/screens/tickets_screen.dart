import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/design_system.dart';
import '../../../payment/presentation/providers/payment_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TicketsScreen extends ConsumerWidget {
  const TicketsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        backgroundColor: AppColors.sand,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(TablerIcons.ticket, size: 48, color: AppColors.muted),
              const SizedBox(height: 16),
              Text(
                'Connecte-toi pour voir tes billets',
                style: GoogleFonts.inter(fontSize: 14, color: AppColors.muted),
              ),
              const SizedBox(height: 12),
              AppCtaButton(
                label: 'Se connecter',
                onPressed: () => context.push('/login'),
              ),
            ],
          ),
        ),
      );
    }

    final ticketsAsync = ref.watch(buyerTicketsProvider(user.uid));

    return Scaffold(
      backgroundColor: AppColors.sand,
      body: Column(
        children: [
          NavyDecorHeader(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Row(
                  children: [
                    const EventBjLogo(onDark: true),
                    const Spacer(),
                    Text(
                      'Mes billets',
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
            child: ticketsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.navy)),
              error: (e, _) => Center(child: Text('Erreur: $e', style: const TextStyle(color: AppColors.muted))),
              data: (tickets) {
                if (tickets.isEmpty) {
                  return Center(
                    child: Text(
                      'Aucun billet pour le moment.\nAchète un ticket depuis une page événement.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(fontSize: 14, color: AppColors.muted),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    final ticket = tickets[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: index < tickets.length - 1 ? 16 : 0),
                      child: AppSurfaceCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    ticket.type,
                                    style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.ink,
                                    ),
                                  ),
                                ),
                                Icon(
                                  TablerIcons.qrcode,
                                  size: 18,
                                  color: AppColors.navy,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'ID: ${ticket.id.substring(0, 8)}...',
                              style: GoogleFonts.inter(fontSize: 12, color: AppColors.muted),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Acheté le ${ticket.purchasedAt.day}/${ticket.purchasedAt.month}/${ticket.purchasedAt.year}',
                              style: GoogleFonts.inter(fontSize: 12, color: AppColors.muted),
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: QrImageView(
                                data: ticket.qrCode,
                                size: 120,
                                backgroundColor: AppColors.white,
                                eyeStyle: const QrEyeStyle(
                                  eyeShape: QrEyeShape.square,
                                  color: AppColors.navy,
                                ),
                                dataModuleStyle: const QrDataModuleStyle(
                                  dataModuleShape: QrDataModuleShape.square,
                                  color: AppColors.ink,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: Text(
                                'Présente ce QR à l’entrée',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppColors.muted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
