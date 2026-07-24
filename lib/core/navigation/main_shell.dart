import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import 'app_router.dart';

/// Shell principal avec bottom navigation — responsabilité Jean.
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.navy.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: navigationShell.currentIndex,
            onTap: _onTap,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(NavIcons.home, size: 20),
                label: 'Accueil',
              ),
              BottomNavigationBarItem(
                icon: Icon(NavIcons.explore, size: 20),
                label: 'Explorer',
              ),
              BottomNavigationBarItem(
                icon: Icon(NavIcons.map, size: 20),
                label: 'Carte',
              ),
              BottomNavigationBarItem(
                icon: Icon(NavIcons.tickets, size: 20),
                label: 'Billets',
              ),
              BottomNavigationBarItem(
                icon: Icon(NavIcons.profile, size: 20),
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
