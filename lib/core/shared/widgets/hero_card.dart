import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../theme/app_colors.dart';
import '../../shared/models/event_model.dart';

class HeroCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback? onTap;

  const HeroCard({super.key, required this.event, this.onTap});

  @override
  Widget build(BuildContext context) {
    final background = _bgColor(event.category);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 220,
        height: 240,
        decoration: AppColors.heroCardDecoration(background),
        child: Stack(
          children: [
            if (_hasImage(event.imageUrl))
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: CachedNetworkImage(
                    imageUrl: event.imageUrl!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(color: background.withValues(alpha: 0.3)),
                    errorWidget: (context, url, error) => Container(color: background),
                  ),
                ),
              ),
            Positioned(
              right: -30,
              bottom: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0x26FFFFFF),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (event.tickets.isNotEmpty)
                    Text(
                      '${event.minPrice.toInt()} FCFA',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  else
                    const Text(
                      'Gratuit',
                      style: TextStyle(
                        color: AppColors.green,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0x26FFFFFF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          event.category,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        event.title,
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: AppColors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              event.location,
                              style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _hasImage(String? url) => url != null && url.isNotEmpty;

  Color _bgColor(String category) {
    switch (category.toLowerCase()) {
      case 'concert':
        return AppColors.navy;
      case 'soiree':
        return const Color(0xFF2D1B4E);
      case 'culture':
        return const Color(0xFF2D1B4E);
      case 'gastronomie':
        return const Color(0xFF3D1F00);
      case 'sport':
        return const Color(0xFF0B4D32);
      default:
        return AppColors.navy;
    }
  }
}
