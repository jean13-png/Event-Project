import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../shared/models/event_model.dart';
import 'event_detail_meta.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback? onTap;

  const EventCard({super.key, required this.event, this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasPrice = event.tickets.isNotEmpty && event.tickets.first.price > 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: AppColors.cardDecoration(),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 10,
                        width: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        event.time.format(context),
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 16),
                  EventDetailMeta(
                    icon: Icons.location_on_outlined,
                    text: event.location,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.navy,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          event.category,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      if (hasPrice)
                        Text(
                          '${event.minPrice.toInt()} FCFA',
                          style: AppTextStyles.pricePaid(),
                        )
                      else
                        Text(
                          'Gratuit',
                          style: AppTextStyles.priceFree(),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              right: -20,
              bottom: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: AppColors.cardDecoBubble(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
