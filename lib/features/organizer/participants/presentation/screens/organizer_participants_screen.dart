import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';
import '../../../../../core/shared/widgets/event_detail_meta.dart';
import '../../../../../core/services/organizer_service.dart';
import '../../../../../core/widgets/design_system.dart';

class OrganizerParticipantsScreen extends ConsumerWidget {
  const OrganizerParticipantsScreen({super.key, this.eventId, this.eventName});

  final String? eventId;
  final String? eventName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.sand,
      appBar: AppBar(
        title: Text(eventName ?? 'Participants'),
        leading: IconButton(onPressed: () => context.pop(), icon: const Icon(TablerIcons.arrow_left, size: 20)),
        actions: [
          IconButton(
            onPressed: () async {
              final service = OrganizerService();
              final csv = eventId != null ? await service.exportParticipantsCsv(eventId!) : 'id,buyerName,buyerPhone,type,price,qrCode,status,purchasedAt\n';
              await SharePlus.instance.share(ShareParams(text: csv));
            },
            icon: const Icon(TablerIcons.file_text, size: 20),
            tooltip: 'Exporter CSV',
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: eventId != null ? OrganizerService().getParticipants(eventId!) : Future.value(<Map<String, dynamic>>[]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.navy));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}', style: const TextStyle(color: AppColors.muted)));
          }
          final participants = snapshot.data ?? <Map<String, dynamic>>[];
          if (participants.isEmpty) {
            return const Center(child: Text('Aucun participant pour le moment.', style: TextStyle(color: AppColors.muted)));
          }
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            itemCount: participants.length,
            itemBuilder: (context, index) {
              final p = participants[index];
              final status = p['status'] ?? 'active';
              final statusColor = status == 'scanned' ? AppColors.orange : AppColors.green;
              final statusLabel = status == 'scanned' ? 'Scanné' : 'Actif';
              return Padding(
                padding: EdgeInsets.only(bottom: index < participants.length - 1 ? 12 : 20),
                child: AppSurfaceCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p['buyerName'] ?? 'Acheteur', style: AppTextStyles.cardTitle),
                            const SizedBox(height: 4),
                            EventDetailMeta(icon: TablerIcons.phone, text: p['buyerPhone'] ?? '-'),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text('${p['type']} • ${p['price']} F', style: AppTextStyles.bodyMuted),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(statusLabel, style: const TextStyle(fontFamily: 'Inter', fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.white)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Icon(TablerIcons.qrcode, size: 20, color: AppColors.navy),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
