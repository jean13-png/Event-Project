import '../utils/app_log.dart';
import '../../features/wallet/data/repositories/wallet_repository.dart';
import '../../features/wallet/data/models/wallet_model.dart';

class WalletService {
  WalletService({WalletRepository? repository})
      : _repo = repository ?? WalletRepository();

  final WalletRepository _repo;

  Future<WalletModel> getWallet(String organizerId) =>
      _repo.getWallet(organizerId);

  Stream<WalletModel> watchWallet(String organizerId) =>
      _repo.watchWallet(organizerId);

  Future<List<WalletTransactionModel>> getTransactions(String userId) =>
      _repo.getTransactions(userId);

  Future<String> requestWithdrawal({
    required String organizerId,
    required int amount,
    required String mobileMoneyNumber,
    required String operator,
  }) async {
    AppLog.info('WalletService.requestWithdrawal');
    return _repo.requestWithdrawal(
      organizerId: organizerId,
      amount: amount,
      mobileMoneyNumber: mobileMoneyNumber,
      operator: operator,
    );
  }
}
