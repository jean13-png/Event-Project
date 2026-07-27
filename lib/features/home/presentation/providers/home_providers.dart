import 'package:flutter/material.dart';
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

final mockOrganizerProvider = Provider<List<EventModel>>((ref) {
  final now = DateTime.now();
  final day = now.day;
  return [
    EventModel(
      id: 'org-1',
      title: 'Nuit de la mode',
      description: 'Défilé mode et networking.',
      category: 'Mode',
      date: DateTime(now.year, now.month, day + 10, 18, 0),
      time: const TimeOfDay(hour: 18, minute: 0),
      location: 'Centre Culturel, Porto-Novo',
      organizerId: 'organizer-1',
      tickets: [
        TicketType(name: 'Standard', price: 5000, totalQty: 200),
        TicketType(name: 'VIP', price: 25000, totalQty: 50),
      ],
      status: EventStatus.published,
      createdAt: now,
      imageUrl: 'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?w=800',
      latitude: 6.4969,
      longitude: 2.6289,
      views: 320,
    ),
    EventModel(
      id: 'org-2',
      title: 'Tech Meetup BJ',
      description: 'Talks, démos et ateliers tech.',
      category: 'Tech',
      date: DateTime(now.year, now.month, day + 14, 9, 0),
      time: const TimeOfDay(hour: 9, minute: 0),
      location: 'Incubateur NTIC, Cotonou',
      organizerId: 'organizer-1',
      tickets: [
        TicketType(name: 'Gratuit', price: 0, totalQty: 120),
      ],
      status: EventStatus.published,
      createdAt: now,
      imageUrl: 'https://images.unsplash.com/photo-1544531586-fde5298cdd40?w=800',
      latitude: 6.3703,
      longitude: 2.3912,
      views: 140,
    ),
    EventModel(
      id: 'org-3',
      title: 'Afro Groove Live',
      description: 'Live band, DJ set et ambiance.',
      category: 'Concert',
      date: DateTime(now.year, now.month, day + 7, 20, 30),
      time: const TimeOfDay(hour: 20, minute: 30),
      location: 'Espace Lagoon, Cotonou',
      organizerId: 'organizer-1',
      tickets: [
        TicketType(name: 'Standard', price: 4000, totalQty: 300),
        TicketType(name: 'VIP', price: 12000, totalQty: 100),
      ],
      status: EventStatus.published,
      createdAt: now,
      imageUrl: 'https://images.unsplash.com/photo-1506157786151-b8498f5f36f5?w=800',
      latitude: 6.3654,
      longitude: 2.4183,
      views: 510,
    ),
  ];
});
