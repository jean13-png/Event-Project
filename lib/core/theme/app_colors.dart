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

  /// Ombre carte : 0 4px 20px rgba(13,59,110,0.08)
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: navy.withValues(alpha: 0.08),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ];
}
