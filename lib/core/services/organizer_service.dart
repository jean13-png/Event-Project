import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../shared/models/event_model.dart';

class OrganizerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  CollectionReference<Map<String, dynamic>> get _eventsRef =>
      _firestore.collection('events');
  CollectionReference<Map<String, dynamic>> get _ticketsRef =>
      _firestore.collection('tickets');

  Future<String> createEvent(EventModel event) async {
    final doc = await _eventsRef.add(event.toFirestore());
    return doc.id;
  }

  Future<void> updateEvent(String eventId, EventModel event) async {
    await _eventsRef.doc(eventId).update(event.toFirestore());
  }

  Future<void> deleteEvent(String eventId) async {
    await _eventsRef.doc(eventId).update({'status': 'cancelled'});
  }

  Future<String?> uploadPoster(File file, String eventId) async {
    try {
      final ref = _storage.ref().child('events/$eventId/poster.jpg');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  Future<String?> uploadAdditionalImage(File file, String eventId, int index) async {
    try {
      final ref = _storage.ref().child('events/$eventId/photo_$index.jpg');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  Future<void> updateTicketSold(String eventId, String ticketTypeName) async {
    final eventSnap = await _eventsRef.doc(eventId).get();
    if (!eventSnap.exists) return;

    final data = eventSnap.data() as Map<String, dynamic>;
    final tickets = (data['tickets'] as List<dynamic>).map((t) {
      final map = Map<String, dynamic>.from(t as Map);
      if (map['name'] == ticketTypeName) {
        map['soldQty'] = (map['soldQty'] ?? 0) + 1;
      }
      return map;
    }).toList();

    await _eventsRef.doc(eventId).update({'tickets': tickets});
  }

  Future<List<Map<String, dynamic>>> getParticipants(String eventId) async {
    final snap = await _ticketsRef
        .where('eventId', isEqualTo: eventId)
        .orderBy('purchasedAt', descending: true)
        .get();

    return snap.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  Future<String> exportParticipantsCsv(String eventId) async {
    final participants = await getParticipants(eventId);

    final buffer = StringBuffer();
    buffer.writeln('ID,Nom,Téléphone,Type,Prix,QR Code,Statut,Date achat');

    for (final p in participants) {
      buffer.writeln(
        '"${p['id']}","${p['buyerName']}","${p['buyerPhone']}","${p['type']}","${p['price']}","${p['qrCode']}","${p['status']}","${p['purchasedAt']}"',
      );
    }

    return buffer.toString();
  }

  Stream<Map<String, dynamic>> getDashboardStats(String organizerId) {
    final eventsQuery = _eventsRef.where('organizerId', isEqualTo: organizerId);

    return eventsQuery.snapshots().asyncMap((eventsSnap) async {
      final eventIds = eventsSnap.docs.map((d) => d.id).toList();

      if (eventIds.isEmpty) {
        return {
          'totalEvents': 0,
          'totalTicketsSold': 0,
          'totalRevenue': 0.0,
          'recentSales': <Map<String, dynamic>>[],
        };
      }

      final ticketsQuery = _ticketsRef
          .where('eventId', whereIn: eventIds)
          .orderBy('purchasedAt', descending: true)
          .limit(10);

      final ticketsSnap = await ticketsQuery.get();

      double totalRevenue = 0;
      int totalSold = 0;

      for (final eventDoc in eventsSnap.docs) {
        final eventData = eventDoc.data();
        for (final ticket in eventData['tickets'] as List<dynamic>?) {
          ?? []
        }) {
          totalSold += ticket['soldQty'] ?? 0;
          totalRevenue += (ticket['price'] ?? 0) * (ticket['soldQty'] ?? 0);
        }
      }

      final recentSales = ticketsSnap.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      return {
        'totalEvents': eventsSnap.docs.length,
        'totalTicketsSold': totalSold,
        'totalRevenue': totalRevenue,
        'recentSales': recentSales,
      };
    });
  }
}
