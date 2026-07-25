import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventbj/core/shared/models/event_model.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _eventsRef =>
      _firestore.collection('events');

  Stream<List<EventModel>> watchFeatured({int limit = 5}) {
    return _eventsRef
        .where('status', isEqualTo: 'published')
        .where('date', isGreaterThanOrEqualTo: Timestamp.now())
        .orderBy('views', descending: true)
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs.map(EventModel.fromFirestore).toList());
  }

  Stream<List<EventModel>> watchTonight() {
    final now = Timestamp.now();
    final endOfDay = Timestamp.fromDate(
      DateTime(now.toDate().year, now.toDate().month, now.toDate().day, 23, 59, 59),
    );
    return _eventsRef
        .where('status', isEqualTo: 'published')
        .where('date', isGreaterThanOrEqualTo: now)
        .where('date', isLessThanOrEqualTo: endOfDay)
        .orderBy('time')
        .snapshots()
        .map((snap) => snap.docs.map(EventModel.fromFirestore).toList());
  }

  Stream<List<EventModel>> watchUpcoming({
    int limit = 20,
    DocumentSnapshot<Map<String, dynamic>>? startAfter,
  }) {
    var query = _eventsRef
        .where('status', isEqualTo: 'published')
        .where('date', isGreaterThanOrEqualTo: Timestamp.now())
        .orderBy('date');

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    query = query.limit(limit);

    return query.snapshots().map((snap) {
      return snap.docs.map(EventModel.fromFirestore).toList();
    });
  }

  Future<List<EventModel>> getUpcomingPaginated({
    int limit = 20,
    DocumentSnapshot<Map<String, dynamic>>? startAfter,
  }) async {
    var query = _eventsRef
        .where('status', isEqualTo: 'published')
        .where('date', isGreaterThanOrEqualTo: Timestamp.now())
        .orderBy('date');

    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }

    query = query.limit(limit);

    final snap = await query.get();
    return snap.docs.map(EventModel.fromFirestore).toList();
  }

  Stream<EventModel?> watchEvent(String eventId) {
    return _eventsRef
        .doc(eventId)
        .snapshots()
        .map((doc) => doc.exists ? EventModel.fromFirestore(doc) : null);
  }

  Future<EventModel?> getEvent(String eventId) async {
    final doc = await _eventsRef.doc(eventId).get();
    if (!doc.exists) return null;
    return EventModel.fromFirestore(doc);
  }

  Future<void> incrementViews(String eventId) async {
    await _eventsRef.doc(eventId).update({
      'views': FieldValue.increment(1),
    });
  }

  Stream<List<EventModel>> watchByOrganizer(String organizerId) {
    return _eventsRef
        .where('organizerId', isEqualTo: organizerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(EventModel.fromFirestore).toList());
  }
}
