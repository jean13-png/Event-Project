/// Portefeuille organisateur — solde, retraits Mobile Money.
/// Responsabilité Jean.
class WalletService {
  Future<Map<String, dynamic>> getWallet(String organizerId) async {
    throw UnimplementedError('À brancher sur Firestore wallets/{organizerId}');
  }

  Future<void> requestWithdrawal({
    required String organizerId,
    required int amount,
    required String mobileMoneyNumber,
    required String operator,
  }) async {
    throw UnimplementedError(
      'À brancher sur Cloud Function processWithdrawal',
    );
  }
}
