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
import '../../../home/presentation/providers/home_providers.dart';

class OrganizerEventsListScreen extends ConsumerWidget {
  const OrganizerEventsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(authStateProvider);

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
                      'Connecte-toi pour gérer tes événements.',
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

        final eventsAsync = ref.watch(organizerEventsProvider(user.uid));

        return Scaffold(
          backgroundColor: AppColors.sand,
          appBar: AppBar(
            title: const Text('Mes événements'),
            leading: IconButton(onPressed: () => context.pop(), icon: const Icon(TablerIcons.arrow_left, size: 20)),
          ),
          body: eventsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator(color: AppColors.navy)),
            error: (e, _) => Center(child: Text('Erreur: $e', style: const TextStyle(color: AppColors.muted))),
            data: (events) {
              if (events.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text('Aucun événement pour le moment.', style: GoogleFonts.inter(color: AppColors.muted)),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final ev = events[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: index < events.length - 1 ? 12 : 0),
                    child: AppSurfaceCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(width: 44, height: 44, decoration: BoxDecoration(color: AppColors.sand, borderRadius: BorderRadius.circular(12)), child: Icon(ev.categoryIcon, size: 20, color: AppColors.navy)),
                              const SizedBox(width: 12),
                              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(ev.title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink)),
                                const SizedBox(height: 2),
                                Text('${ev.dateLabel} · ${ev.location}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.muted)),
                              ])),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: AppSecondaryButton(
                                  label: 'Voir',
                                  icon: TablerIcons.eye,
                                  onPressed: () => context.push('/events/${ev.id}'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: AppSecondaryButton(
                                  label: 'Partager',
                                  icon: TablerIcons.share,
                                  onPressed: () {
                                    final link = 'https://mymood.page.link/events/${ev.id}';
                                    SharePlus.instance.share(ShareParams(text: '$link\n\n${ev.title} — ${ev.dateLabel}\nRéserve ta place maintenant sur MyMood !'));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => context.push(AppRoutes.newEvent),
            backgroundColor: AppColors.navy,
            icon: const Icon(TablerIcons.plus, color: AppColors.white),
            label: const Text('Nouvel événement', style: TextStyle(color: AppColors.white)),
          ),
        );
      },
    );
  }
}
