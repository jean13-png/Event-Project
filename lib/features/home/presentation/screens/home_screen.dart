import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

import '../../../../core/shared/models/event_model.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/shared/widgets/event_card.dart';
import '../../../../core/shared/widgets/hero_card.dart';
import '../providers/home_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuredAsync = ref.watch(featuredEventsProvider);
    final tonightAsync = ref.watch(tonightEventsProvider);
    final upcomingAsync = ref.watch(upcomingEventsProvider);
    final organizerAsync = ref.watch(mockOrganizerProvider);

    return Scaffold(
      backgroundColor: AppColors.sand,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(featuredEventsProvider);
            ref.invalidate(tonightEventsProvider);
            ref.invalidate(upcomingEventsProvider);
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _Header(),
              _SearchBar(),
              _SectionTitle(title: 'À la une', onSeeAll: () {}),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 210,
                  child: featuredAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator(color: AppColors.navy)),
                    error: (e, _) => Center(child: Text('Erreur: $e', style: const TextStyle(color: AppColors.muted))),
                    data: (events) => _HorizontalList(events: events, emptyText: 'Aucun événement en vedette'),
                  ),
                ),
              ),
              _SectionTitle(title: 'Ce soir', onSeeAll: () {}),
              SliverToBoxAdapter(
                child: tonightAsync.when(
                  loading: () => const SizedBox(height: 120, child: Center(child: CircularProgressIndicator(color: AppColors.navy))),
                  error: (e, _) => Center(child: Text('Erreur: $e', style: const TextStyle(color: AppColors.muted))),
                  data: (events) {
                    if (events.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Text('Aucun événement ce soir', style: TextStyle(color: AppColors.muted)),
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
                                  top: entry.key == 0 ? 0 : 12,
                                ),
                                child: EventCard(event: entry.value),
                              ))
                          .toList(),
                    );
                  },
                ),
              ),
              _SectionTitle(title: 'Tes événements', onSeeAll: () {}),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 280,
                  child: _OrganizerList(events: organizerAsync),
                ),
              ),
              _SectionTitle(title: 'Prochainement', onSeeAll: () {}),
              SliverToBoxAdapter(
                child: upcomingAsync.when(
                  loading: () => const SizedBox(height: 120, child: Center(child: CircularProgressIndicator(color: AppColors.navy))),
                  error: (e, _) => Center(child: Text('Erreur: $e', style: const TextStyle(color: AppColors.muted))),
                  data: (events) {
                    if (events.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Text('Aucun événement à venir', style: TextStyle(color: AppColors.muted)),
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
                                  bottom: entry.key < events.length - 1 ? 12 : 24,
                                ),
                                child: EventCard(event: entry.value),
                              ))
                          .toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
      child: Row(
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
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'MyMood',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.navy,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_outlined, color: AppColors.navy, size: 22),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.person_outlined, color: AppColors.navy, size: 22),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x120D3B6E),
                    offset: Offset(0, 3),
                    blurRadius: 16,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Rechercher événement, lieu...',
                  hintStyle: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: AppColors.muted,
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 14, right: 8),
                    child: Icon(Icons.search_outlined, color: AppColors.muted, size: 20),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.circular(14),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x120D3B6E),
                  offset: Offset(0, 3),
                  blurRadius: 16,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.tune_outlined, color: AppColors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget implements PreferredSizeWidget {
  const _SectionTitle({required this.title, required this.onSeeAll});

  final String title;
  final VoidCallback onSeeAll;

  @override
  Size get preferredSize => const Size(0, 56);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
              color: AppColors.ink,
            ),
          ),
          TextButton(onPressed: onSeeAll, child: const Text('Tout voir')),
        ],
      ),
    );
  }
}

class _HorizontalList extends StatelessWidget {
  const _HorizontalList({required this.events, this.emptyText = 'Aucun élément'});

  final List<EventModel> events;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Text(emptyText, style: const TextStyle(color: AppColors.muted)),
        ),
      );
    }
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final ev = events[index];
        return Padding(
          padding: EdgeInsets.only(right: index < events.length - 1 ? 14 : 20),
          child: HeroCard(event: ev),
        );
      },
    );
  }
}

class _OrganizerList extends StatelessWidget {
  const _OrganizerList({required this.events});

  final List<EventModel> events;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const Center(
        child: Text('Aucun événement créé', style: TextStyle(color: AppColors.muted)),
      );
    }
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final ev = events[index];
        final minPrice = ev.tickets.isEmpty ? 0 : ev.tickets.map((t) => t.price).reduce((a, b) => a < b ? a : b);
        return Padding(
          padding: EdgeInsets.only(right: index < events.length - 1 ? 14 : 20),
          child: SizedBox(
            width: 210,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: HeroCard(event: ev),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _ChipDot(icon: TablerIcons.report_money, label: '${minPrice.toInt()} FCFA'),
                    const Spacer(),
                    _ChipDot(icon: TablerIcons.ticket, label: '${ev.tickets.length} types'),
                  ],
                ),
                const SizedBox(height: 6),
                const Divider(height: 1, thickness: 1),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ChipDot extends StatelessWidget {
  const _ChipDot({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0x1F0D3B6E)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.navy),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontFamily: 'Inter', fontSize: 12, color: AppColors.navy)),
        ],
      ),
    );
  }
}
