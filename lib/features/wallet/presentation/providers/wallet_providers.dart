import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/wallet_service.dart';
import '../../data/models/wallet_model.dart';

final walletServiceProvider = Provider<WalletService>((ref) {
  return WalletService();
});

/// Utilise l'uid connecté, sinon le wallet démo organisateur.
final activeWalletIdProvider = Provider<String>((ref) {
  return FirebaseAuth.instance.currentUser?.uid ?? 'demo-organizer';
});

final walletProvider = StreamProvider<WalletModel>((ref) {
  final id = ref.watch(activeWalletIdProvider);
  return ref.watch(walletServiceProvider).watchWallet(id);
});

final walletTransactionsProvider =
    FutureProvider<List<WalletTransactionModel>>((ref) async {
  final id = ref.watch(activeWalletIdProvider);
  return ref.watch(walletServiceProvider).getTransactions(id);
});
