import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Placeholder Carte — module Épiphane.
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sand,
      appBar: AppBar(title: const Text('Carte')),
      body: Center(
        child: Text(
          'Module Épiphane — carte des événements',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
