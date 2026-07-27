import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/shared/models/event_model.dart';
import '../../../../core/shared/widgets/event_card.dart';
import '../../../../core/shared/widgets/hero_card.dart';
import '../../../../core/shared/widgets/section_header.dart';
import '../providers/home_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuredAsync = ref.watch(featuredEventsProvider);
    final tonightAsync = ref.watch(tonightEventsProvider);
    final upcomingAsync = ref.watch(upcomingEventsProvider);

    return Scaffold(
      backgroundColor: AppColors.sand,
      body: RefreshIndicator(
        color: AppColors.orange,
        backgroundColor: AppColors.white,
        onRefresh: () async {
          ref.invalidate(featuredEventsProvider);
          ref.invalidate(tonightEventsProvider);
          ref.invalidate(upcomingEventsProvider);
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverToBoxAdapter(
              child: _buildHeader(context),
            ),
            SliverToBoxAdapter(
              child: _buildSearchBar(),
            ),
            SliverToBoxAdapter(
              child: const SizedBox(height: 12),
            ),
            SliverToBoxAdapter(
              child: _buildFeaturedSection(featuredAsync),
            ),
            SliverToBoxAdapter(
              child: const SizedBox(height: 16),
            ),
            SliverToBoxAdapter(
              child: _buildTonightSection(tonightAsync),
            ),
            SliverToBoxAdapter(
              child: const SizedBox(height: 16),
            ),
            SliverToBoxAdapter(
              child: _buildUpcomingSection(upcomingAsync),
            ),
            SliverToBoxAdapter(
              child: const SizedBox(height: 80),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
          // DESIGN.md: Anneau circulaire semi-transparent en blanc (opacité 6%) en haut à droite
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
          // DESIGN.md: Bulle orange (opacité 18%) en bas à droite
          Positioned(
            bottom: 30,
            right: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.orange.withValues(alpha: 0.18),
              ),
            ),
          ),
          // DESIGN.md: Forme géométrique blanc très transparent en bas à gauche
          Positioned(
            bottom: -20,
            left: -20,
            child: Transform.rotate(
              angle: 0.8,
              child: Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          // Content
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 48), // Padding bottom for search bar overlap
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: AppColors.orange,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: const Icon(
                              TablerIcons.calendar_event,
                              color: AppColors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'MyMood',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              TablerIcons.bell,
                              color: AppColors.white,
                              size: 22,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 4),
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.white.withValues(alpha: 0.1),
                            ),
                            child: const Icon(
                              TablerIcons.user,
                              color: AppColors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Bonjour, prêt à sortir ?',
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                      letterSpacing: -0.5,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Découvrez les meilleurs spots et événements du Bénin.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.white.withValues(alpha: 0.8),
                      height: 1.5,
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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Transform.translate(
        offset: const Offset(0, -26), // Overlaps header as per DESIGN.md
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x140D3B6E), // 8% opacity navy
                offset: Offset(0, 4),
                blurRadius: 20,
              ),
            ],
          ),
          child: TextField(
            style: GoogleFonts.inter(fontSize: 14, color: AppColors.ink),
            decoration: InputDecoration(
              hintText: 'Rechercher un événement, un lieu...',
              hintStyle: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.muted,
              ),
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 18, right: 10),
                child: Icon(
                  TablerIcons.search,
                  color: AppColors.muted,
                  size: 20,
                ),
              ),
              prefixIconConstraints: const BoxConstraints(minWidth: 40),
              suffixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.navy,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      TablerIcons.adjustments_horizontal,
                      color: AppColors.white,
                      size: 18,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedSection(AsyncValue<List<EventModel>> async) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'À la une',
          onSeeAll: null,
        ),
        SizedBox(
          height: 250, // Slightly taller for premium feel
          child: async.when(
            loading: () => const Center(child: CircularProgressIndicator(color: AppColors.navy)),
            error: (e, _) => Center(child: Text('Erreur: $e', style: GoogleFonts.inter(color: AppColors.muted))),
            data: (events) {
              if (events.isEmpty) return const SizedBox.shrink();
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: index < events.length - 1 ? 16 : 0),
                    child: HeroCard(event: events[index]),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTonightSection(AsyncValue<List<EventModel>> async) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Ce soir',
          onSeeAll: null,
        ),
        SizedBox(
          height: 145, // Fixed height for EventCard
          child: async.when(
            loading: () => const Center(child: CircularProgressIndicator(color: AppColors.navy)),
            error: (e, _) => Center(child: Text('Erreur: $e', style: GoogleFonts.inter(color: AppColors.muted))),
            data: (events) {
              if (events.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [BoxShadow(color: Color(0x140D3B6E), blurRadius: 20, offset: Offset(0, 4))],
                    ),
                    child: Center(
                      child: Text(
                        'Aucun événement prévu ce soir. Reposez-vous bien !',
                        style: GoogleFonts.inter(fontSize: 13, color: AppColors.muted),
                      ),
                    ),
                  ),
                );
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 290,
                    child: Padding(
                      padding: EdgeInsets.only(right: index < events.length - 1 ? 14 : 0),
                      child: EventCard(event: events[index]),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingSection(AsyncValue<List<EventModel>> async) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(
          title: 'Prochainement',
          onSeeAll: null,
        ),
        async.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(40),
            child: Center(child: CircularProgressIndicator(color: AppColors.navy)),
          ),
          error: (e, _) => Center(child: Text('Erreur: $e', style: GoogleFonts.inter(color: AppColors.muted))),
          data: (events) {
            if (events.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Center(
                  child: Text(
                    'La programmation arrive bientôt.',
                    style: GoogleFonts.inter(fontSize: 14, color: AppColors.muted),
                  ),
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true, // Needed because it's inside CustomScrollView
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: events.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: index < events.length - 1 ? 14 : 0),
                  child: EventCard(event: events[index]),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

