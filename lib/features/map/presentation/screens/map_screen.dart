import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/app_colors.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0EAE1), // Fake map ground color
      body: Stack(
        children: [
          // Background Map Pattern (Fake)
          Positioned.fill(
            child: Opacity(
              opacity: 0.4,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.muted.withValues(alpha: 0.1)),
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Fake Map Pins
          Positioned(
            top: 200,
            left: 100,
            child: _buildMapPin(AppColors.orange, true),
          ),
          Positioned(
            top: 350,
            right: 80,
            child: _buildMapPin(AppColors.navy, false),
          ),
          Positioned(
            top: 150,
            right: 120,
            child: _buildMapPin(AppColors.green, false),
          ),

          // Floating Search Bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 54,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x140D3B6E),
                            offset: Offset(0, 4),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Icon(TablerIcons.search, color: AppColors.muted),
                          ),
                          Expanded(
                            child: Text(
                              'Autour de moi...',
                              style: GoogleFonts.inter(color: AppColors.muted, fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      color: AppColors.navy,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x140D3B6E),
                          offset: Offset(0, 4),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: const Icon(TablerIcons.adjustments_horizontal, color: AppColors.white),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Sheet Event Preview
          Positioned(
            bottom: 30, // Above bottom nav bar
            left: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A0D3B6E),
                    offset: Offset(0, 10),
                    blurRadius: 30,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.navy,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(TablerIcons.map_pin, color: AppColors.white, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.orange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'INTÉGRATION À VENIR',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.orange,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Carte interactive',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Google Maps sera bientôt disponible.',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPin(Color color, bool active) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: active ? Border.all(color: AppColors.white, width: 3) : null,
            boxShadow: const [
              BoxShadow(
                color: Color(0x40000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: const Icon(TablerIcons.music, color: AppColors.white, size: 18),
        ),
        if (active)
          Container(
            width: 2,
            height: 10,
            color: color,
          ),
      ],
    );
  }
}
