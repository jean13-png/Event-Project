import 'package:cloud_firestore/cloud_firestore.dart';

class TicketModel {
  const TicketModel({
    required this.id,
    required this.eventId,
    required this.buyerId,
    required this.buyerPhone,
    required this.buyerName,
    required this.type,
    required this.price,
    required this.qrCode,
    required this.status,
    required this.purchasedAt,
  });

  final String id;
  final String eventId;
  final String buyerId;
  final String buyerPhone;
  final String buyerName;
  final String type;
  final int price;
  final String qrCode;
  final String status;
  final DateTime purchasedAt;

  factory TicketModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    final purchasedAt = data['purchasedAt'];
    return TicketModel(
      id: doc.id,
      eventId: data['eventId'] as String? ?? '',
      buyerId: data['buyerId'] as String? ?? '',
      buyerPhone: data['buyerPhone'] as String? ?? '',
      buyerName: data['buyerName'] as String? ?? '',
      type: data['type'] as String? ?? '',
      price: (data['price'] as num?)?.toInt() ?? 0,
      qrCode: data['qrCode'] as String? ?? doc.id,
      status: data['status'] as String? ?? 'active',
      purchasedAt: purchasedAt is Timestamp
          ? purchasedAt.toDate()
          : DateTime.now(),
    );
  }
}
