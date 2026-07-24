import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Placeholder Explorer — module Épiphane.
class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sand,
      appBar: AppBar(title: const Text('Explorer')),
      body: Center(
        child: Text(
          'Module Épiphane — recherche & filtres',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
