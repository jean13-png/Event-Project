import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/event_model.dart';
import '../../data/repositories/event_repository.dart';

final eventRepositoryProvider = Provider<EventRepository>((ref) {
  return EventRepository();
});

final eventProvider =
    FutureProvider.family<EventModel, String>((ref, eventId) async {
  final repo = ref.watch(eventRepositoryProvider);
  if (eventId == 'demo-concert') {
    return repo.ensureDemoEvent();
  }
  final event = await repo.getEvent(eventId);
  if (event == null) {
    // Fallback démo si l'id est inconnu en phase de dev
    return repo.ensureDemoEvent();
  }
  await repo.incrementViews(eventId);
  return event;
});

final eventSuggestionsProvider =
    FutureProvider.family<List<EventModel>, String>((ref, excludeId) async {
  final repo = ref.watch(eventRepositoryProvider);
  final list = await repo.getPublishedSuggestions(excludeId: excludeId);
  if (list.isEmpty) {
    final demo = await repo.ensureDemoEvent();
    return excludeId == demo.id ? <EventModel>[] : [demo];
  }
  return list;
});
