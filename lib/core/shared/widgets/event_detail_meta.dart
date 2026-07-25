import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class EventDetailMeta extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? iconColor;

  const EventDetailMeta({
    super.key,
    required this.icon,
    required this.text,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: iconColor ?? AppColors.muted,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.muted,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
