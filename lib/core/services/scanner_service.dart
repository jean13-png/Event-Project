import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ScannerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> scanTicket(String qrCodeContent) async {
    final ticketSnap = await _firestore
        .collection('tickets')
        .where('qrCode', isEqualTo: qrCodeContent)
        .limit(1)
        .get();

    if (ticketSnap.docs.isEmpty) return null;

    final doc = ticketSnap.docs.first;
    final data = doc.data();

    return {
      'id': doc.id,
      'eventId': data['eventId'],
      'buyerName': data['buyerName'] ?? '',
      'type': data['type'] ?? '',
      'price': (data['price'] as num?)?.toDouble() ?? 0,
      'status': data['status'] ?? 'active',
      'purchasedAt': (data['purchasedAt'] as Timestamp?)?.toDate(),
    };
  }

  Future<void> markAsScanned(String ticketId) async {
    await _firestore.collection('tickets').doc(ticketId).update({
      'status': 'scanned',
      'scannedAt': Timestamp.now(),
    });
  }

  Future<void> preloadEventTickets(String eventId) async {
    final snap = await _firestore
        .collection('tickets')
        .where('eventId', isEqualTo: eventId)
        .get();

    final tickets = snap.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'qrCode': data['qrCode'] ?? '',
        'status': data['status'] ?? 'active',
        'buyerName': data['buyerName'] ?? '',
        'type': data['type'] ?? '',
      };
    }).toList();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('offline_tickets_$eventId', jsonEncode(tickets));
  }

  Future<List<Map<String, dynamic>>> getOfflineTickets(String eventId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('offline_tickets_$eventId');
    if (raw == null) return [];

    final List<dynamic> decoded = jsonDecode(raw);
    return decoded.cast<Map<String, dynamic>>();
  }
}
