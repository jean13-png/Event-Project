import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../providers/scanner_providers.dart';

class ScannerScreen extends ConsumerWidget {
  const ScannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isScanning = ref.watch(scannerIsScanningProvider);
    final result = ref.watch(scannerResultProvider);

    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(child: _buildScannerArea(context, ref, isScanning, result)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Scanner',
            style: AppTextStyles.h2.copyWith(color: AppColors.white),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.info_outlined, color: AppColors.white, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerArea(BuildContext context, WidgetRef ref, bool isScanning, Map<String, dynamic>? result) {
    if (result != null) {
      return _buildResultCard(context, ref, result);
    }

    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: MobileScanner(
              onDetect: (capture) {
                if (!isScanning) return;
                final barcode = capture.barcodes.firstOrNull;
                if (barcode == null) return;

                final code = barcode.rawValue;
                if (code == null || code.isEmpty) return;

                ref.read(scannerIsScanningProvider.notifier).setScanning(false);
                _handleScan(context, ref, code);
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'Scanne le QR code du ticket',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: AppColors.white.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard(BuildContext context, WidgetRef ref, Map<String, dynamic> result) {
    final status = result['status'] as String? ?? 'active';
    final isValid = status == 'active';
    final isScanned = status == 'scanned';

    Color backgroundColor;
    Color textColor;
    String title;
    String subtitle;

    if (isScanned) {
      backgroundColor = const Color(0xFFFFF0E6);
      textColor = AppColors.orange;
      title = 'Ticket déjà scanné';
      subtitle = 'Premier scan : ${result['scannedAt'] ?? 'inconnu'}';
    } else if (isValid) {
      backgroundColor = const Color(0xFFEBF7F2);
      textColor = AppColors.green;
      title = 'Ticket valide';
      subtitle = '${result['buyerName']} • ${result['type']}';
    } else {
      backgroundColor = const Color(0xFFFFEBEB);
      textColor = Colors.red;
      title = 'Ticket invalide';
      subtitle = 'Ce ticket ne peut pas être utilisé';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isScanned
                    ? Icons.warning_amber_rounded
                    : isValid
                        ? Icons.check_circle_rounded
                        : Icons.cancel_rounded,
                size: 48,
                color: textColor,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: AppColors.muted,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  ref.read(scannerResultProvider.notifier).clear();
                  ref.read(scannerIsScanningProvider.notifier).setScanning(true);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.navy,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  'Nouveau scan',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleScan(BuildContext context, WidgetRef ref, String code) async {
    final service = ref.read(scannerServiceProvider);
    final ticket = await service.scanTicket(code);

    if (ticket == null) {
      ref.read(scannerResultProvider.notifier).setResult({
        'status': 'invalid',
        'buyerName': 'Inconnu',
        'type': '-',
      });
      return;
    }

    final ticketId = ticket['id'] as String;
    final status = ticket['status'] as String;

    if (status == 'active') {
      await service.markAsScanned(ticketId);
    }

    ref.read(scannerResultProvider.notifier).setResult({
      ...ticket,
      'scannedAt': status == 'scanned' ? ticket['purchasedAt'] : null,
    });
  }
}
