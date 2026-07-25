import 'package:flutter/material.dart';

/// Palette EventBJ — source : DESIGN.md
abstract final class AppColors {
  static const Color navy = Color(0xFF0D3B6E);
  static const Color orange = Color(0xFFE8501A);
  static const Color sand = Color(0xFFF5F4EF);
  static const Color ink = Color(0xFF1A1A2E);
  static const Color white = Color(0xFFFFFFFF);
  static const Color muted = Color(0xFF6B7280);
  static const Color green = Color(0xFF22A96A);

  /// Onglets bottom nav inactifs — DESIGN.md §8
  static const Color navInactive = Color(0xFFB0B5BD);

  // Badges catégorie (pastel)
  static const Color concertBg = Color(0xFFEEF2FF);
  static const Color concertFg = Color(0xFF0D3B6E);
  static const Color soireeBg = Color(0xFFFFF0EB);
  static const Color soireeFg = Color(0xFFC03D10);
  static const Color freeBg = Color(0xFFEBF7F2);
  static const Color freeFg = Color(0xFF157A4A);

  /// Ombre carte : 0 4px 20px rgba(13,59,110,0.08)
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: navy.withValues(alpha: 0.08),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ];

  /// Ombre bottom nav : 0 -4px 24px rgba(0,0,0,0.07)
  static List<BoxShadow> get navShadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.07),
          blurRadius: 24,
          offset: const Offset(0, -4),
        ),
      ];

  static BoxDecoration cardDecoration() {
    return BoxDecoration(
      color: white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: cardShadow,
    );
  }

  static BoxDecoration cardDecoBubble() {
    return const BoxDecoration(
      shape: BoxShape.circle,
      color: Color(0x140D3B6E),
    );
  }

  static BoxDecoration heroCardDecoration(int colorValue) {
    return BoxDecoration(
      color: Color(colorValue),
      borderRadius: BorderRadius.circular(22),
    );
  }

  static BoxDecoration categoryPillActiveDecoration() {
    return BoxDecoration(
      color: navy,
      borderRadius: BorderRadius.circular(30),
    );
  }

  static BoxDecoration categoryPillInactiveDecoration() {
    return BoxDecoration(
      color: white,
      borderRadius: BorderRadius.circular(30),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0F000000),
          offset: Offset(0, 2),
          blurRadius: 8,
          spreadRadius: 0,
        ),
      ],
    );
  }
}
