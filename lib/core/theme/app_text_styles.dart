import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get _base400 => const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        color: AppColors.ink,
      );

  static TextStyle get _base600 => const TextStyle(
        fontFamily: 'Inter',
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      );

  static TextStyle get h1 => _base600.copyWith(fontSize: 20, height: 1.3);

  static TextStyle get h2 => _base600.copyWith(fontSize: 16, height: 1.3, letterSpacing: -0.3);

  static TextStyle get cardTitle => _base600.copyWith(fontSize: 15, height: 1.3);

  static TextStyle get body => _base400.copyWith(fontSize: 14, height: 1.5);

  static TextStyle get bodyMuted => _base400.copyWith(
        fontSize: 12,
        height: 1.5,
        color: AppColors.muted,
      );

  static TextStyle get label => _base400.copyWith(
        fontSize: 11,
        height: 1.3,
        color: AppColors.muted,
      );

  static TextStyle pricePaid() =>
      _base600.copyWith(fontSize: 15, color: AppColors.orange);

  static TextStyle priceFree() =>
      _base600.copyWith(fontSize: 15, color: AppColors.green);

  static TextStyle primaryButton(GestureTapCallback? onTap) {
    return _base600.copyWith(
      fontSize: 14,
      color: AppColors.white,
      letterSpacing: 0.2,
    );
  }

  static TextStyle bottomNavActive() => _base600.copyWith(
        fontSize: 11,
        color: AppColors.navy,
      );

  static TextStyle bottomNavInactive() => _base400.copyWith(
        fontSize: 11,
        color: const Color(0xFFB0B5BD),
      );
}
