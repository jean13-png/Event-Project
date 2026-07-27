import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/design_system.dart';

/// Confirmation paiement + QR ticket.
class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({
    super.key,
    required this.eventId,
    required this.buyerName,
    required this.ticketName,
    required this.amountXof,
    this.ticketIds = const [],
  });

  final String eventId;
  final String buyerName;
  final String ticketName;
  final int amountXof;
  final List<String> ticketIds;

  String get _qrPayload {
    if (ticketIds.isNotEmpty) {
      return 'mymood:ticket:${ticketIds.first}:$eventId';
    }
    return 'mymood:$eventId:${buyerName.hashCode}:$ticketName:${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sand,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.green.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  TablerIcons.circle_check,
                  color: AppColors.green,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Paiement confirmé',
                style: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                amountXof == 0
                    ? 'Ta réservation est prête.'
                    : 'Ticket envoyé par SMS.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.muted,
                ),
              ),
              const SizedBox(height: 24),
              AppSurfaceCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    QrImageView(
                      data: _qrPayload,
                      size: 180,
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
                    const SizedBox(height: 16),
                    Text(
                      buyerName,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ticketName,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    PriceText(amountXof: amountXof, fontSize: 15),
                  ],
                ),
              ),
              const Spacer(),
              AppCtaButton(
                label: 'Voir mes billets',
                icon: TablerIcons.ticket,
                onPressed: () => context.go(AppRoutes.tickets),
              ),
              const SizedBox(height: 12),
              AppSecondaryButton(
                label: 'Retour à l’accueil',
                onPressed: () => context.go(AppRoutes.home),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
