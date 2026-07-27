import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/design_system.dart';
import '../providers/event_providers.dart';

/// Page événement publique (lien partageable) — sans compte requis.
class EventPageScreen extends ConsumerWidget {
  const EventPageScreen({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventAsync = ref.watch(eventProvider(eventId));
    final suggestionsAsync = ref.watch(eventSuggestionsProvider(eventId));

    return Scaffold(
      backgroundColor: AppColors.sand,
      body: eventAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.navy)),
        error: (e, _) => Center(child: Text('Erreur: $e', style: const TextStyle(color: AppColors.muted))),
        data: (event) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 240,
                pinned: true,
                backgroundColor: AppColors.navy,
                leading: IconButton(
                  icon: const Icon(TablerIcons.arrow_left, size: 20),
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go(AppRoutes.home);
                    }
                  },
                ),
                actions: [
                  IconButton(
                    icon: const Icon(TablerIcons.share, size: 20),
                    tooltip: 'Partager',
                    onPressed: () {
                      Clipboard.setData(
                        ClipboardData(
                          text: 'https://eventbj.page.link/events/${event.id}',
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Lien copié')),
                      );
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: NavyDecorHeader(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 24),
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: AppColors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              event.categoryIcon,
                              size: 28,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CategoryBadge(
                        label: event.category,
                        icon: event.categoryIcon,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        event.title,
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                          letterSpacing: -0.3,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 12),
                      EventMetaRow(
                        icon: TablerIcons.calendar,
                        text: event.dateLabel,
                      ),
                      const SizedBox(height: 6),
                      EventMetaRow(
                        icon: TablerIcons.clock,
                        text: event.timeLabel,
                      ),
                      const SizedBox(height: 6),
                      EventMetaRow(
                        icon: TablerIcons.map_pin,
                        text: event.location,
                      ),
                      const SizedBox(height: 22),
                      Text(
                        'Description',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.3,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        event.description.isEmpty
                            ? 'Description à venir.'
                            : event.description,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 22),
                      Text(
                        'Tickets',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.3,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...event.tickets.map(
                        (t) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: AppSurfaceCard(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        t.type,
                                        style: GoogleFonts.inter(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.ink,
                                        ),
                                      ),
                                      if (t.description.isNotEmpty) ...[
                                        const SizedBox(height: 4),
                                        Text(
                                          t.description,
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: AppColors.muted,
                                          ),
                                        ),
                                      ],
                                      const SizedBox(height: 4),
                                      Text(
                                        '${t.available} places',
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          color: AppColors.muted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  t.price == 0 ? 'Gratuit' : '${t.price} FCFA',
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: t.price == 0 ? AppColors.green : AppColors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      AppCtaButton(
                        label: 'Acheter un ticket',
                        icon: TablerIcons.ticket,
                        onPressed: () => context.push(
                          '/events/${event.id}/checkout',
                        ),
                      ),
                      const SizedBox(height: 26),
                      Text(
                        'Autres événements',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.3,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 12),
                      suggestionsAsync.when(
                        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.navy)),
                        error: (e, _) => Center(child: Text('Erreur: $e', style: const TextStyle(color: AppColors.muted))),
                        data: (suggestions) {
                          if (suggestions.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text('Aucune suggestion', style: TextStyle(color: AppColors.muted)),
                            );
                          }
                          return Column(
                            children: suggestions
                                .map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: AppSurfaceCard(
                                      onTap: () => context.push('/events/${e.id}'),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 44,
                                            height: 44,
                                            decoration: BoxDecoration(
                                              color: AppColors.sand,
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              e.categoryIcon,
                                              size: 20,
                                              color: AppColors.navy,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  e.title,
                                                  style: GoogleFonts.inter(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.ink,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  '${e.dateLabel} · ${e.city}',
                                                  style: GoogleFonts.inter(
                                                    fontSize: 12,
                                                    color: AppColors.muted,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Text(
                                            e.minPrice == 0 ? 'Gratuit' : '${e.minPrice} F',
                                            style: GoogleFonts.inter(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: e.minPrice == 0 ? AppColors.green : AppColors.orange,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
