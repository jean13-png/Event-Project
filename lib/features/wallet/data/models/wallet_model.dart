import 'package:cloud_firestore/cloud_firestore.dart';

class WalletModel {
  const WalletModel({
    required this.organizerId,
    required this.balance,
    required this.pendingBalance,
    required this.totalEarned,
    this.currency = 'XOF',
  });

  final String organizerId;
  final int balance;
  final int pendingBalance;
  final int totalEarned;
  final String currency;

  factory WalletModel.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return WalletModel(
      organizerId: doc.id,
      balance: (data['balance'] as num?)?.toInt() ?? 0,
      pendingBalance: (data['pendingBalance'] as num?)?.toInt() ?? 0,
      totalEarned: (data['totalEarned'] as num?)?.toInt() ?? 0,
      currency: data['currency'] as String? ?? 'XOF',
    );
  }

  static WalletModel empty(String organizerId) => WalletModel(
        organizerId: organizerId,
        balance: 0,
        pendingBalance: 0,
        totalEarned: 0,
      );
}

class WalletTransactionModel {
  const WalletTransactionModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.reference,
    required this.status,
    required this.createdAt,
    this.title = '',
  });

  final String id;
  final String userId;
  final String type; // credit | debit
  final int amount;
  final String reference;
  final String status;
  final DateTime createdAt;
  final String title;

  bool get isCredit => type == 'credit';

  factory WalletTransactionModel.fromDoc(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    final createdAt = data['createdAt'];
    final metadata = data['metadata'];
    return WalletTransactionModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      type: data['type'] as String? ?? 'credit',
      amount: (data['amount'] as num?)?.toInt() ?? 0,
      reference: data['reference'] as String? ?? '',
      status: data['status'] as String? ?? 'pending',
      createdAt: createdAt is Timestamp ? createdAt.toDate() : DateTime.now(),
      title: metadata is Map
          ? (metadata['title'] as String? ?? '')
          : (data['title'] as String? ?? ''),
    );
  }
}
