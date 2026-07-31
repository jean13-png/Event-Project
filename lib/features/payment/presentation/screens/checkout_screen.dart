import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sand,
      body: Center(
        child: Text('Checkout — eventId: $eventId'),
      ),
    );
  }
}
