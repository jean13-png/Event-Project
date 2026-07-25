import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../shared/models/category_model.dart';

class CategoryPill extends StatelessWidget {
  final CategoryModel category;
  final bool isActive;
  final VoidCallback? onTap;

  const CategoryPill({
    super.key,
    required this.category,
    this.isActive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration:
            isActive ? AppColors.categoryPillActiveDecoration() : AppColors.categoryPillInactiveDecoration(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _iconFromName(category.iconName),
              size: 16,
              color: isActive ? AppColors.white : AppColors.ink,
            ),
            const SizedBox(width: 6),
            Text(
              category.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isActive ? AppColors.white : AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFromName(String name) {
    switch (name) {
      case 'music':
        return Icons.music_note_outlined;
      case 'moon-stars':
        return Icons.nightlight_round_outlined;
      case 'trophy':
        return Icons.emoji_events_outlined;
      case 'palette':
        return Icons.palette_outlined;
      case 'tools-kitchen-2':
        return Icons.restaurant_outlined;
      case 'microphone-2':
        return Icons.mic_outlined;
      default:
        return Icons.event_outlined;
    }
  }
}
