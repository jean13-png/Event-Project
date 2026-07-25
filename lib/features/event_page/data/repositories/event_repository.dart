import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/utils/app_log.dart';
import '../models/event_model.dart';

class EventRepository {
  EventRepository({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _events =>
      _db.collection('events');

  Future<EventModel?> getEvent(String eventId) async {
    AppLog.info('Firestore get event/$eventId');
    final snap = await _events.doc(eventId).get();
    if (!snap.exists) return null;
    return EventModel.fromDoc(snap);
  }

  Stream<EventModel?> watchEvent(String eventId) {
    return _events.doc(eventId).snapshots().map((snap) {
      if (!snap.exists) return null;
      return EventModel.fromDoc(snap);
    });
  }

  Future<List<EventModel>> getPublishedSuggestions({
    String? excludeId,
    int limit = 5,
  }) async {
    final query = await _events
        .where('status', isEqualTo: 'published')
        .limit(limit + 1)
        .get();

    return query.docs
        .map(EventModel.fromDoc)
        .where((e) => e.id != excludeId)
        .take(limit)
        .toList();
  }

  /// Assure qu'un événement démo existe pour les tests (idempotent).
  Future<EventModel> ensureDemoEvent() async {
    const id = 'demo-concert';
    final existing = await getEvent(id);
    if (existing != null) return existing;

    AppLog.info('Seed Firestore events/demo-concert');
    final event = EventModel(
      id: id,
      title: 'Afro Night Cotonou',
      description:
          'Une soirée afrobeat avec les meilleurs artistes de la scène locale. '
          'Dress code chic décontracté. Parking disponible sur place.',
      category: 'Concert',
      date: DateTime(2025, 8, 2),
      time: '21:00',
      locationName: 'Palais des Congrès',
      city: 'Cotonou',
      organizerId: 'demo-organizer',
      tickets: const [
        EventTicketType(
          type: 'Standard',
          price: 5000,
          totalQty: 120,
          soldQty: 0,
          description: 'Accès général',
        ),
        EventTicketType(
          type: 'VIP',
          price: 15000,
          totalQty: 40,
          soldQty: 0,
          description: 'Zone VIP + 1 consommation',
        ),
        EventTicketType(
          type: 'Pass presse',
          price: 0,
          totalQty: 10,
          soldQty: 0,
          description: 'Sur invitation',
        ),
      ],
      status: 'published',
      shareLink: 'https://eventbj.page.link/events/$id',
    );

    await _events.doc(id).set({
      ...event.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Wallet démo organisateur
    await _db.collection('wallets').doc('demo-organizer').set({
      'balance': 0,
      'pendingBalance': 0,
      'totalEarned': 0,
      'currency': 'XOF',
    }, SetOptions(merge: true));

    return event;
  }

  Future<void> incrementViews(String eventId) async {
    try {
      await _events.doc(eventId).update({
        'views': FieldValue.increment(1),
      });
    } catch (e, st) {
      AppLog.error('incrementViews échoué', e, st);
    }
  }
}
