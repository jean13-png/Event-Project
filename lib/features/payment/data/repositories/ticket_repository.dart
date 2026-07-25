import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/utils/app_log.dart';
import '../models/ticket_model.dart';

class TicketRepository {
  TicketRepository({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;
  final _uuid = const Uuid();

  CollectionReference<Map<String, dynamic>> get _tickets =>
      _db.collection('tickets');

  Future<TicketModel> createTicket({
    required String eventId,
    required String buyerId,
    required String buyerPhone,
    required String buyerName,
    required String type,
    required int price,
  }) async {
    final id = _uuid.v4();
    final qrCode = 'eventbj:$eventId:$id';
    AppLog.info('Création ticket $id event=$eventId');

    await _tickets.doc(id).set({
      'eventId': eventId,
      'buyerId': buyerId,
      'buyerPhone': buyerPhone,
      'buyerName': buyerName,
      'type': type,
      'price': price,
      'qrCode': qrCode,
      'status': 'active',
      'purchasedAt': FieldValue.serverTimestamp(),
    });

    // Incrémente soldQty sur le type de ticket de l'événement
    final eventRef = _db.collection('events').doc(eventId);
    await _db.runTransaction((tx) async {
      final snap = await tx.get(eventRef);
      if (!snap.exists) return;
      final data = snap.data()!;
      final raw = List<Map<String, dynamic>>.from(
        (data['tickets'] as List<dynamic>? ?? [])
            .map((e) => Map<String, dynamic>.from(e as Map)),
      );
      for (var i = 0; i < raw.length; i++) {
        if (raw[i]['type'] == type) {
          raw[i]['soldQty'] = ((raw[i]['soldQty'] as num?)?.toInt() ?? 0) + 1;
        }
      }
      tx.update(eventRef, {'tickets': raw});
    });

    final created = await _tickets.doc(id).get();
    return TicketModel.fromDoc(created);
  }

  Stream<List<TicketModel>> watchBuyerTickets(String buyerId) {
    return _tickets
        .where('buyerId', isEqualTo: buyerId)
        .orderBy('purchasedAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(TicketModel.fromDoc).toList());
  }

  Future<List<TicketModel>> getBuyerTickets(String buyerId) async {
    final snap = await _tickets
        .where('buyerId', isEqualTo: buyerId)
        .orderBy('purchasedAt', descending: true)
        .get();
    return snap.docs.map(TicketModel.fromDoc).toList();
  }

  Future<List<TicketModel>> getTicketsByPhone(String phone) async {
    final snap = await _tickets.where('buyerPhone', isEqualTo: phone).get();
    return snap.docs.map(TicketModel.fromDoc).toList();
  }
}
