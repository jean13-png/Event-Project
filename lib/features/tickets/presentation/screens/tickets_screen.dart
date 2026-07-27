import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/design_system.dart';
import '../../../payment/presentation/providers/payment_providers.dart';

class TicketsScreen extends ConsumerWidget {
  const TicketsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = FirebaseAuth.instance.currentUser;
    
    if (user == null) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
        ),
        child: Scaffold(
          backgroundColor: AppColors.sand,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.navy.withValues(alpha: 0.08),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      )
                    ],
                  ),
                  child: const Icon(TablerIcons.ticket, size: 48, color: AppColors.navy),
                ),
                const SizedBox(height: 24),
                Text(
                  'Connectez-vous',
                  style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.ink),
                ),
                const SizedBox(height: 8),
                Text(
                  'Connectez-vous pour voir\net gérer vos billets.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 14, color: AppColors.muted, height: 1.5),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: AppCtaButton(
                    label: 'Se connecter',
                    onPressed: () => context.push('/login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final ticketsAsync = ref.watch(buyerTicketsProvider(user.uid));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.sand,
        body: Stack(
          children: [
            // Fixes white gap on overscroll by adding navy at the very top
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 300,
              child: Container(color: AppColors.navy),
            ),
            CustomScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                SliverToBoxAdapter(
                  child: _buildHeader(),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    color: AppColors.sand, // Solid background
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                    child: ticketsAsync.when(
                      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.navy)),
                      error: (e, _) => Center(child: Text('Erreur: $e', style: GoogleFonts.inter(color: AppColors.muted))),
                      data: (tickets) {
                        if (tickets.isEmpty) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 40),
                              const Icon(TablerIcons.ticket_off, size: 48, color: AppColors.muted),
                              const SizedBox(height: 16),
                              Text(
                                'Aucun billet',
                                style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.ink),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Vous n\'avez pas encore acheté\nde billets pour un événement.',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(fontSize: 14, color: AppColors.muted, height: 1.5),
                              ),
                            ],
                          );
                        }
                        return Column(
                          children: tickets.map((ticket) => Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: _TicketCard(ticket: ticket),
                          )).toList(),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Stack(
        children: [
          // DESIGN.md shapes
          Positioned(
            top: -40,
            right: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.06), width: 24),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 40,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.orange.withValues(alpha: 0.18),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const MyMoodLogo(onDark: true),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Mes Billets',
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Retrouvez tous vos accès ici.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  final dynamic ticket;

  const _TicketCard({required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140D3B6E),
            offset: Offset(0, 8),
            blurRadius: 24,
          ),
        ],
      ),
      child: Column(
        children: [
          // Haut du ticket
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.orange,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              ticket.type.toUpperCase(),
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Billet MyMood',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.ink,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.sand,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(TablerIcons.ticket, color: AppColors.navy, size: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(TablerIcons.clock, size: 14, color: AppColors.muted),
                    const SizedBox(width: 6),
                    Text(
                      'Acheté le ${ticket.purchasedAt.day.toString().padLeft(2, '0')}/${ticket.purchasedAt.month.toString().padLeft(2, '0')}/${ticket.purchasedAt.year}',
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.muted),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(TablerIcons.hash, size: 14, color: AppColors.muted),
                    const SizedBox(width: 6),
                    Text(
                      'Réf: ${ticket.id.substring(0, 8).toUpperCase()}',
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.muted),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Séparateur Ticket (ligne pointillée)
          Row(
            children: [
              Container(
                height: 20,
                width: 10,
                decoration: const BoxDecoration(
                  color: AppColors.sand,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final dashCount = (constraints.constrainWidth() / 8).floor();
                    return Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(dashCount, (_) {
                        return const SizedBox(
                          width: 4,
                          height: 1.5,
                          child: DecoratedBox(decoration: BoxDecoration(color: Color(0xFFE5E7EB))),
                        );
                      }),
                    );
                  },
                ),
              ),
              Container(
                height: 20,
                width: 10,
                decoration: const BoxDecoration(
                  color: AppColors.sand,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
              ),
            ],
          ),

          // Bas du ticket avec le QR
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: QrImageView(
                    data: ticket.qrCode,
                    size: 140,
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
                const SizedBox(height: 16),
                Text(
                  'Présentez ce QR Code à l\'entrée',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.navy,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
