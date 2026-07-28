import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/navigation/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/design_system.dart';
import '../../../../core/shared/widgets/category_pill.dart';
import '../../../../core/shared/models/category_model.dart';
import '../../../../core/shared/models/event_model.dart';
import '../../../../core/shared/widgets/event_card.dart';
import '../providers/explore_providers.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventsAsync = ref.watch(exploreEventsProvider);

    return Scaffold(
      backgroundColor: AppColors.sand,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NavyDecorHeader(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
                child: Row(
                  children: [
                    const MyMoodLogo(onDark: true),
                    const Spacer(),
                    IconButton(
                      tooltip: 'Notifications',
                      onPressed: () => context.push(AppRoutes.notifications),
                      icon: const Icon(
                        TablerIcons.bell,
                        color: AppColors.white,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          _buildSearchBar(ref),
          const SizedBox(height: 18),
          _buildCategoryFilters(ref),
          const SizedBox(height: 12),
          _buildPriceFilters(ref),
          const SizedBox(height: 8),
          Expanded(child: _buildResults(context, ref, eventsAsync)),
        ],
      ),
    );
  }

  Widget _buildSearchBar(WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Rechercher un événement, un lieu...',
          hintStyle: GoogleFonts.inter(
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
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.navy, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 14),
        ),
        onChanged: (value) {
          ref.read(exploreFiltersProvider.notifier).setTextQuery(value);
        },
      ),
    );
  }

  Widget _buildCategoryFilters(WidgetRef ref) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          CategoryPill(
            category: CategoryModel(id: 'all', label: 'Tout', iconName: ''),
            isActive: ref.read(exploreFiltersProvider).categoryId == null,
            onTap: () => ref.read(exploreFiltersProvider.notifier).setCategory(null),
          ),
          const SizedBox(width: 8),
          ...CategoryModel.all.map((cat) {
            final active = ref.read(exploreFiltersProvider).categoryId == cat.id;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CategoryPill(
                category: cat,
                isActive: active,
                onTap: () => ref.read(exploreFiltersProvider.notifier).setCategory(cat.id),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPriceFilters(WidgetRef ref) {
    final filters = ref.read(exploreFiltersProvider);
    final isAll = !filters.onlyFree && !filters.onlyPaid;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _PriceChip(
            label: 'Tous',
            isActive: isAll,
            onTap: () => ref.read(exploreFiltersProvider.notifier).setPriceFilter(null, null),
          ),
          const SizedBox(width: 8),
          _PriceChip(
            label: 'Gratuit',
            isActive: filters.onlyFree,
            onTap: () => ref.read(exploreFiltersProvider.notifier).setPriceFilter(true, false),
          ),
          const SizedBox(width: 8),
          _PriceChip(
            label: 'Payant',
            isActive: filters.onlyPaid,
            onTap: () => ref.read(exploreFiltersProvider.notifier).setPriceFilter(false, true),
          ),
        ],
      ),
    );
  }

  Widget _buildResults(BuildContext context, WidgetRef ref, AsyncValue<List<EventModel>> async) {
    return async.when(
      loading: () => const Center(child: CircularProgressIndicator(color: AppColors.navy)),
      error: (e, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'Erreur: $e',
            style: GoogleFonts.inter(fontSize: 14, color: AppColors.muted),
          ),
        ),
      ),
      data: (events) {
        if (events.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              'Aucun événement trouvé',
              style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: AppColors.muted),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 80),
          itemCount: events.length,
          itemBuilder: (context, index) {
            final event = events[index];
            return Padding(
              padding: EdgeInsets.only(bottom: index < events.length - 1 ? 12 : 20),
              child: Column(
                children: [
                  EventCard(event: event),
                  const SizedBox(height: 8),
                  AppCtaButton(
                    label: event.minPrice == 0 ? 'Réserver gratuitement' : 'Participer',
                    icon: event.minPrice == 0 ? TablerIcons.ticket : TablerIcons.arrow_right,
                    onPressed: () => context.push('/events/${event.id}'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _PriceChip extends StatelessWidget {
  const _PriceChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.navy : AppColors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: isActive
              ? null
              : const [
                  BoxShadow(
                    color: Color(0x0F000000),
                    offset: Offset(0, 2),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ],
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isActive ? AppColors.white : AppColors.ink,
          ),
        ),
      ),
    );
  }
}
