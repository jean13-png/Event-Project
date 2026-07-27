import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_router.dart';

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
    final index = navigationShell.currentIndex;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: AppColors.navShadow,
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
            child: Row(
              children: [
                _NavItem(
                  icon: NavIcons.home,
                  label: 'Accueil',
                  selected: index == 0,
                  onTap: () => _onTap(0),
                ),
                _NavItem(
                  icon: NavIcons.explore,
                  label: 'Explorer',
                  selected: index == 1,
                  onTap: () => _onTap(1),
                ),
                _NavItem(
                  icon: NavIcons.map,
                  label: 'Carte',
                  selected: index == 2,
                  onTap: () => _onTap(2),
                ),
                _NavItem(
                  icon: NavIcons.tickets,
                  label: 'Billets',
                  selected: index == 3,
                  onTap: () => _onTap(3),
                ),
                _NavItem(
                  icon: NavIcons.profile,
                  label: 'Profil',
                  selected: index == 4,
                  onTap: () => _onTap(4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? AppColors.navy : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: selected ? AppColors.white : AppColors.navInactive,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: selected ? AppTextStyles.bottomNavActive() : AppTextStyles.bottomNavInactive(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
