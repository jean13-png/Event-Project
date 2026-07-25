import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(featuredEventsProvider);
            ref.invalidate(tonightEventsProvider);
            ref.invalidate(upcomingEventsProvider);
          },
          child: ListView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            padding: EdgeInsets.zero,
            children: [
              _buildHeader(context),
              _buildSearchBar(),
              const SizedBox(height: 22),
              _buildFeaturedSection(featuredAsync),
              _buildTonightSection(tonightAsync),
              _buildUpcomingSection(upcomingAsync),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
      decoration: const BoxDecoration(
        color: AppColors.navy,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: AppColors.orange,
                      borderRadius: BorderRadius.all(Radius.circular(9)),
                    ),
                    child: const Icon(
                      Icons.calendar_today_outlined,
                      color: AppColors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'EventBJ',
                    style: TextStyle(
                      fontFamily: 'Inter',
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
                      Icons.notifications_outlined,
                      color: AppColors.white,
                      size: 22,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.person_outlined,
                      color: AppColors.white,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'Bonjour',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Découvre les événements près de toi',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.white.withValues(alpha: 0.8),
              height: 1.5,
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
        offset: const Offset(0, -20),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x140D3B6E),
                offset: Offset(0, 4),
                blurRadius: 20,
                spreadRadius: 0,
              ),
            ],
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Rechercher un événement, un lieu...',
              hintStyle: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: AppColors.muted,
              ),
              prefixIcon: const Padding(
                padding: EdgeInsets.only(left: 16, right: 8),
                child: Icon(
                  Icons.search_outlined,
                  color: AppColors.muted,
                  size: 20,
                ),
              ),
              suffixIcon: Container(
                margin: const EdgeInsets.only(right: 8),
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.all(Radius.circular(9)),
                ),
                child: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.tune_outlined,
                    color: AppColors.white,
                    size: 18,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
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
          height: 240,
          child: async.when(
            loading: () => const Center(child: CircularProgressIndicator(color: AppColors.navy)),
            error: (e, _) => Center(child: Text('Erreur: $e', style: const TextStyle(color: AppColors.muted))),
            data: (events) {
              if (events.isEmpty) return const SizedBox.shrink();
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(right: index < events.length - 1 ? 14 : 20),
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
          height: 140,
          child: async.when(
            loading: () => const Center(child: CircularProgressIndicator(color: AppColors.navy)),
            error: (e, _) => Center(child: Text('Erreur: $e', style: const TextStyle(color: AppColors.muted))),
            data: (events) {
              if (events.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Aucun événement ce soir',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.muted),
                  ),
                );
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 280,
                    child: Padding(
                      padding: EdgeInsets.only(right: index < events.length - 1 ? 12 : 20),
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
          loading: () => const Center(child: CircularProgressIndicator(color: AppColors.navy)),
          error: (e, _) => Center(child: Text('Erreur: $e', style: const TextStyle(color: AppColors.muted))),
          data: (events) {
            if (events.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Text(
                  'Aucun événement à venir',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.muted),
                ),
              );
            }
            return Column(
              children: events
                  .asMap()
                  .entries
                  .map((entry) => Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: entry.key < events.length - 1 ? 12 : 20,
                        ),
                        child: EventCard(event: entry.value),
                      ))
                  .toList(),
            );
          },
        ),
      ],
    );
  }
}
