import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/data/mock_data.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/design_system.dart';

/// Mes billets — aperçu UI (tickets mock après achat).
class TicketsScreen extends StatelessWidget {
  const TicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final event = MockData.demoConcert;

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
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              children: [
                AppSurfaceCard(
                  onTap: () => context.push('/events/${event.id}'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              event.title,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: AppColors.ink,
                              ),
                            ),
                          ),
                          const Icon(
                            TablerIcons.qrcode,
                            size: 18,
                            color: AppColors.navy,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      EventMetaRow(
                        icon: TablerIcons.calendar,
                        text: event.dateLabel,
                      ),
                      const SizedBox(height: 4),
                      EventMetaRow(
                        icon: TablerIcons.map_pin,
                        text: '${event.venue}, ${event.city}',
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: QrImageView(
                          data: 'eventbj-ticket-demo',
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
                          'Standard · Présente ce QR à l’entrée',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.muted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Achete un ticket depuis une page événement pour en ajouter.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.muted,
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
