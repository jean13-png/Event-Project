import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/scanner_service.dart';

class ScannerNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void setScanning(bool value) => state = value;
}

class ScannerResultNotifier extends Notifier<Map<String, dynamic>?> {
  @override
  Map<String, dynamic>? build() => null;

  void setResult(Map<String, dynamic>? result) => state = result;

  void clear() => state = null;
}

final scannerIsScanningProvider =
    NotifierProvider<ScannerNotifier, bool>(ScannerNotifier.new);

final scannerResultProvider =
    NotifierProvider<ScannerResultNotifier, Map<String, dynamic>?>(ScannerResultNotifier.new);

final scannerServiceProvider = Provider<ScannerService>((ref) {
  return ScannerService();
});

final offlineTicketsProvider = FutureProvider.family<List<Map<String, dynamic>>, String>((ref, eventId) {
  final service = ref.watch(scannerServiceProvider);
  return service.getOfflineTickets(eventId);
});
