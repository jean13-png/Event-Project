import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const int navyValue = 0xFF0D3B6E;
  static const int orangeValue = 0xFFE8501A;
  static const int sandValue = 0xFFF5F4EF;
  static const int inkValue = 0xFF1A1A2E;
  static const int whiteValue = 0xFFFFFFFF;
  static const int mutedValue = 0xFF6B7280;
  static const int greenValue = 0xFF22A96A;

  static const Color navy = Color(navyValue);
  static const Color orange = Color(orangeValue);
  static const Color sand = Color(sandValue);
  static const Color ink = Color(inkValue);
  static const Color white = Color(whiteValue);
  static const Color muted = Color(mutedValue);
  static const Color green = Color(greenValue);

  static const Color scaffoldBackground = sand;
  static const Color cardBackground = white;
  static const Color headerBackground = navy;

  static BoxDecoration cardDecoration() {
    return BoxDecoration(
      color: white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          color: Color(0x140D3B6E),
          offset: Offset(0, 4),
          blurRadius: 20,
          spreadRadius: 0,
        ),
      ],
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
