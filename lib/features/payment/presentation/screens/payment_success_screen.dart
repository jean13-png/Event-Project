import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({
    super.key,
    this.eventId,
    this.buyerName,
    this.ticketName,
    this.amountXof,
    this.ticketIds,
  });

  final String? eventId;
  final String? buyerName;
  final String? ticketName;
  final int? amountXof;
  final List<String>? ticketIds;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sand,
      body: Center(
        child: Text('Paiement réussi — eventId: $eventId'),
      ),
    );
  }
}
