import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/utils/app_log.dart';
import '../models/wallet_model.dart';

class WalletRepository {
  WalletRepository({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  Future<WalletModel> getWallet(String organizerId) async {
    AppLog.info('Firestore wallet/$organizerId');
    final snap = await _db.collection('wallets').doc(organizerId).get();
    if (!snap.exists) {
      await _db.collection('wallets').doc(organizerId).set({
        'balance': 0,
        'pendingBalance': 0,
        'totalEarned': 0,
        'currency': 'XOF',
      });
      return WalletModel.empty(organizerId);
    }
    return WalletModel.fromDoc(snap);
  }

  Stream<WalletModel> watchWallet(String organizerId) {
    return _db.collection('wallets').doc(organizerId).snapshots().map((snap) {
      if (!snap.exists) return WalletModel.empty(organizerId);
      return WalletModel.fromDoc(snap);
    });
  }

  Future<List<WalletTransactionModel>> getTransactions(String userId) async {
    final snap = await _db
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(30)
        .get();
    return snap.docs.map(WalletTransactionModel.fromDoc).toList();
  }

  Future<void> creditWallet({
    required String organizerId,
    required int amount,
    required String reference,
    required String title,
  }) async {
    if (amount <= 0) return;
    final walletRef = _db.collection('wallets').doc(organizerId);
    final txRef = _db.collection('transactions').doc();

    await _db.runTransaction((tx) async {
      final snap = await tx.get(walletRef);
      final balance = (snap.data()?['balance'] as num?)?.toInt() ?? 0;
      final total = (snap.data()?['totalEarned'] as num?)?.toInt() ?? 0;
      tx.set(
        walletRef,
        {
          'balance': balance + amount,
          'totalEarned': total + amount,
          'currency': 'XOF',
        },
        SetOptions(merge: true),
      );
      tx.set(txRef, {
        'userId': organizerId,
        'type': 'credit',
        'amount': amount,
        'reference': reference,
        'status': 'completed',
        'createdAt': FieldValue.serverTimestamp(),
        'metadata': {'title': title},
      });
    });
  }

  Future<String> requestWithdrawal({
    required String organizerId,
    required int amount,
    required String mobileMoneyNumber,
    required String operator,
  }) async {
    AppLog.info('Retrait $amount XOF → $operator $mobileMoneyNumber');
    final walletRef = _db.collection('wallets').doc(organizerId);
    final withdrawalRef = _db.collection('withdrawals').doc();
    final txRef = _db.collection('transactions').doc();

    await _db.runTransaction((tx) async {
      final snap = await tx.get(walletRef);
      final balance = (snap.data()?['balance'] as num?)?.toInt() ?? 0;
      if (amount <= 0 || amount > balance) {
        throw StateError('Solde insuffisant');
      }
      final pending =
          (snap.data()?['pendingBalance'] as num?)?.toInt() ?? 0;

      tx.update(walletRef, {
        'balance': balance - amount,
        'pendingBalance': pending + amount,
      });
      tx.set(withdrawalRef, {
        'organizerId': organizerId,
        'amount': amount,
        'mobileMoneyNumber': mobileMoneyNumber,
        'operator': operator,
        'status': 'pending',
        'requestedAt': FieldValue.serverTimestamp(),
      });
      tx.set(txRef, {
        'userId': organizerId,
        'type': 'debit',
        'amount': amount,
        'reference': withdrawalRef.id,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
        'metadata': {'title': 'Retrait ${operator.toUpperCase()}'},
      });
    });

    return withdrawalRef.id;
  }
}
