import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/navigation/app_router.dart';
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
                  child: const Icon(TablerIcons.qrcode, size: 32, color: AppColors.navy),
                ),
                const SizedBox(height: 16),
                Text(
                  'Connecte-toi pour voir tes pass',
                  style: GoogleFonts.inter(fontSize: 14, color: AppColors.muted),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                AppCtaButton(
                  label: 'Se connecter',
                  onPressed: () => context.push(AppRoutes.login),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final ticketsAsync = ref.watch(buyerTicketsProvider(user.uid));

    return Scaffold(
      backgroundColor: AppColors.sand,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            decoration: const BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                const MyMoodLogo(onDark: true),
                const Spacer(),
                Text(
                  'Mes Pass',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ticketsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator(color: AppColors.navy)),
              error: (e, _) => Center(child: Text('Erreur: $e', style: const TextStyle(color: AppColors.muted))),
              data: (tickets) {
                if (tickets.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Aucun pass pour le moment.\nAchète un billet depuis une page événement.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(fontSize: 14, color: AppColors.muted),
                      ),
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
                            const SizedBox(height: 6),
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
