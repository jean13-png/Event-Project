import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/shared/models/event_model.dart';
import '../../../../core/shared/widgets/event_card.dart';
import '../../../../core/shared/widgets/hero_card.dart';
import '../../../../core/shared/widgets/section_header.dart';
import '../providers/home_providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _selectedCategory = 'Tous';

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Tous', 'icon': TablerIcons.apps},
    {'name': 'Concert', 'icon': TablerIcons.music},
    {'name': 'Soirée', 'icon': TablerIcons.moon_stars},
    {'name': 'Culture', 'icon': TablerIcons.palette},
    {'name': 'Sport', 'icon': TablerIcons.trophy},
    {'name': 'Food', 'icon': TablerIcons.tools_kitchen_2},
  ];

  @override
  Widget build(BuildContext context) {
    final featuredAsync = ref.watch(featuredEventsProvider);
    final tonightAsync = ref.watch(tonightEventsProvider);
    final upcomingAsync = ref.watch(upcomingEventsProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.sand,
        body: Stack(
          children: [
            // Fixes the white gap on overscroll by providing a navy background at the very top
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 300,
              child: Container(color: AppColors.navy),
            ),
            RefreshIndicator(
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
                  SliverToBoxAdapter(child: _buildHeader(context)),
                  SliverToBoxAdapter(
                    child: Container(
                      color: AppColors.sand, // Solid background covers the fixed navy block when scrolling
                      child: Column(
                        children: [
                          _buildCategoryFilters(),
                          const SizedBox(height: 16),
                          _buildFeaturedSection(featuredAsync),
                          const SizedBox(height: 24),
                          _buildTonightSection(tonightAsync),
                          const SizedBox(height: 32),
                          _buildOrganizerPromoBanner(),
                          const SizedBox(height: 32),
                          _buildUpcomingSection(upcomingAsync),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        // Background Navy with Decors
        Container(
          width: double.infinity,
          height: 220,
          decoration: const BoxDecoration(
            color: AppColors.navy,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          child: Stack(
            children: [
              // DESIGN.md: Deco shapes
              Positioned(
                top: -30,
                right: -30,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 30),
                  ),
                ),
              ),
              Positioned(
                bottom: 40,
                right: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.orange.withValues(alpha: 0.15),
                  ),
                ),
              ),
              Positioned(
                bottom: 20,
                left: -20,
                child: Transform.rotate(
                  angle: 0.5,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Content
        SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bienvenue sur MyMood',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.white.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Prêt à vibrer ?',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _buildHeaderIconButton(TablerIcons.bell, hasBadge: true),
                        const SizedBox(width: 12),
                        _buildHeaderIconButton(TablerIcons.user),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  'Explorez la vibe\nde la ville ce soir.',
                  style: GoogleFonts.inter(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                    letterSpacing: -0.5,
                    height: 1.15,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Floating Search Bar over the bottom edge
        Positioned(
          bottom: 0,
          left: 20,
          right: 20,
          child: Transform.translate(
            offset: const Offset(0, 26),
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Color(0x140D3B6E), offset: Offset(0, 8), blurRadius: 24),
                ],
              ),
              child: TextField(
                style: GoogleFonts.inter(fontSize: 15, color: AppColors.ink),
                decoration: InputDecoration(
                  hintText: 'Rechercher un événement, un lieu...',
                  hintStyle: GoogleFonts.inter(fontSize: 14, color: AppColors.muted),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Icon(TablerIcons.search, color: AppColors.navy, size: 22),
                  ),
                  prefixIconConstraints: const BoxConstraints(minWidth: 40),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.sand,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(TablerIcons.adjustments_horizontal, color: AppColors.navy, size: 20),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 17),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderIconButton(IconData icon, {bool hasBadge = false}) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.white.withValues(alpha: 0.1)),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(icon, color: AppColors.white, size: 20),
          if (hasBadge)
            Positioned(
              top: 10,
              right: 12,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.orange,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return Padding(
      padding: const EdgeInsets.only(top: 48), // Space for floating search bar
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final category = _categories[index];
            final isSelected = _selectedCategory == category['name'];
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = category['name'] as String),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.navy : AppColors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: isSelected
                      ? const [BoxShadow(color: Color(0x330D3B6E), offset: Offset(0, 4), blurRadius: 12)]
                      : const [BoxShadow(color: Color(0x0A000000), offset: Offset(0, 2), blurRadius: 8)],
                  border: isSelected ? null : Border.all(color: AppColors.muted.withValues(alpha: 0.1)),
                ),
                child: Row(
                  children: [
                    Icon(
                      category['icon'] as IconData,
                      size: 16,
                      color: isSelected ? AppColors.white : AppColors.ink,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      category['name'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        color: isSelected ? AppColors.white : AppColors.ink,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFeaturedSection(AsyncValue<List<EventModel>> async) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: SectionHeader(title: 'À la une', onSeeAll: () {}),
        ),
        SizedBox(
          height: 280, // Taller, more impactful hero cards
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
                    child: Transform.scale(
                      scale: 1.0, // Could add a subtle scale animation on scroll here
                      child: HeroCard(event: events[index]),
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

  Widget _buildTonightSection(AsyncValue<List<EventModel>> async) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: SectionHeader(title: 'Ce soir & Demain', onSeeAll: () {}),
        ),
        SizedBox(
          height: 155, // Fixed height for standard EventCard
          child: async.when(
            loading: () => const Center(child: CircularProgressIndicator(color: AppColors.navy)),
            error: (e, _) => Center(child: Text('Erreur: $e', style: GoogleFonts.inter(color: AppColors.muted))),
            data: (events) {
              if (events.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.muted.withValues(alpha: 0.1)),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(TablerIcons.sofa, color: AppColors.muted, size: 28),
                          const SizedBox(height: 8),
                          Text(
                            'Rien de prévu pour ce soir.',
                            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.ink),
                          ),
                          Text(
                            'Profitez-en pour vous reposer !',
                            style: GoogleFonts.inter(fontSize: 13, color: AppColors.muted),
                          ),
                        ],
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
                    width: 300,
                    child: Padding(
                      padding: EdgeInsets.only(right: index < events.length - 1 ? 16 : 0),
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

  Widget _buildOrganizerPromoBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.navy,
          borderRadius: BorderRadius.circular(24),
          image: const DecorationImage(
            image: AssetImage('assets/images/pattern.png'), // Fake pattern overlay, handle safely
            opacity: 0.05,
            fit: BoxFit.cover,
          ),
          boxShadow: const [BoxShadow(color: Color(0x330D3B6E), offset: Offset(0, 12), blurRadius: 30)],
        ),
        child: Row(
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
                      'ESPACE ORGANISATEUR',
                      style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w800, color: AppColors.white, letterSpacing: 0.5),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Vendez vos tickets\nen ligne, sans effort.',
                    style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.white, height: 1.2),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Paiements par Moov & MTN.',
                    style: GoogleFonts.inter(fontSize: 13, color: AppColors.white.withValues(alpha: 0.7)),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      foregroundColor: AppColors.navy,
                      elevation: 0,
                      minimumSize: const Size(0, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Text('Créer un événement', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(TablerIcons.ticket, color: AppColors.white, size: 40),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingSection(AsyncValue<List<EventModel>> async) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: SectionHeader(title: 'Prochainement', onSeeAll: () {}),
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
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Center(
                  child: Text(
                    'Restez à l\'écoute pour les prochains événements.',
                    style: GoogleFonts.inter(fontSize: 14, color: AppColors.muted),
                  ),
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: events.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: index < events.length - 1 ? 16 : 0),
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

