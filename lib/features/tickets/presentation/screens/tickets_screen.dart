import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Placeholder Mes billets — lié au profil / tickets (Épiphane + Jean).
class TicketsScreen extends StatelessWidget {
  const TicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sand,
      appBar: AppBar(title: const Text('Mes billets')),
      body: Center(
        child: Text(
          'Tes tickets QR apparaîtront ici après achat.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
