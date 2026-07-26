import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/event_service.dart';
import '../../../../core/shared/models/event_model.dart';

class ExploreFilters {
  final String? categoryId;
  final String? cityQuery;
  final String? textQuery;
  final bool onlyFree;
  final bool onlyPaid;

  const ExploreFilters({
    this.categoryId,
    this.cityQuery,
    this.textQuery,
    this.onlyFree = false,
    this.onlyPaid = false,
  });

  ExploreFilters copyWith({
    String? categoryId,
    String? cityQuery,
    String? textQuery,
    bool? onlyFree,
    bool? onlyPaid,
  }) {
    return ExploreFilters(
      categoryId: categoryId ?? this.categoryId,
      cityQuery: cityQuery ?? this.cityQuery,
      textQuery: textQuery ?? this.textQuery,
      onlyFree: onlyFree ?? this.onlyFree,
      onlyPaid: onlyPaid ?? this.onlyPaid,
    );
  }
}

class ExploreFiltersNotifier extends Notifier<ExploreFilters> {
  @override
  ExploreFilters build() => const ExploreFilters();

  void setCategory(String? categoryId) {
    state = state.copyWith(categoryId: categoryId);
  }

  void setCityQuery(String? cityQuery) {
    state = state.copyWith(cityQuery: cityQuery);
  }

  void setTextQuery(String? textQuery) {
    state = state.copyWith(textQuery: textQuery);
  }

  void setPriceFilter(bool? onlyFree, bool? onlyPaid) {
    state = state.copyWith(
      onlyFree: onlyFree ?? false,
      onlyPaid: onlyPaid ?? false,
    );
  }

  void reset() {
    state = const ExploreFilters();
  }
}

final exploreFiltersProvider =
    NotifierProvider<ExploreFiltersNotifier, ExploreFilters>(ExploreFiltersNotifier.new);

final eventServiceProvider = Provider<EventService>((ref) {
  return EventService();
});

final exploreEventsProvider = StreamProvider<List<EventModel>>((ref) {
  final filters = ref.watch(exploreFiltersProvider);
  final service = ref.watch(eventServiceProvider);

  return service.watchExplore(
    category: filters.categoryId,
    cityQuery: filters.cityQuery,
    onlyFree: filters.onlyFree,
    onlyPaid: filters.onlyPaid,
    textQuery: filters.textQuery,
  );
});
