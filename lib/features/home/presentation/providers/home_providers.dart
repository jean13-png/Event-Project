import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/event_service.dart';
import '../../../../core/shared/models/event_model.dart';

final eventServiceProvider = Provider<EventService>((ref) {
  return EventService();
});

final featuredEventsProvider = StreamProvider<List<EventModel>>((ref) {
  final service = ref.watch(eventServiceProvider);
  return service.watchFeatured(limit: 5);
});

final tonightEventsProvider = StreamProvider<List<EventModel>>((ref) {
  final service = ref.watch(eventServiceProvider);
  return service.watchTonight();
});

final upcomingEventsProvider = StreamProvider<List<EventModel>>((ref) {
  final service = ref.watch(eventServiceProvider);
  return service.watchUpcoming(limit: 20);
});
