import 'package:flutter/material.dart';

/// Harraka Agent colour tokens.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFFEC3013);
  static const Color primaryDark = Color(0xFFB8301A);
  static const Color primaryLight = Color(0xFFFDEDE9);

  static const Color secondary = Color(0xFF157A41);
  static const Color secondaryLight = Color(0xFFE6F7ED);

  static const Color warning = Color(0xFFF5A623);
  static const Color warningText = Color(0xFF8A5A06);
  static const Color warningLight = Color(0xFFFDF3E0);
  static const Color error = Color(0xFFD93A3A);

  static const Color ink = Color(0xFF1A1A1A);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textTertiary = Color(0xFF8A8683);
  static const Color textDisabled = Color(0xFFB0B0B0);

  static const Color background = Color(0xFFFAF9F8);
  static const Color card = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF4F2F1);
  static const Color surfaceMuted = Color(0xFFEFEDEC);
  static const Color border = Color(0xFFEEEBE9);
  static const Color borderStrong = Color(0xFFE8E5E3);

  /// Delivered pill on the ink header card.
  static const Color mintOnInk = Color(0xFF8FF0BB);
  static const Color mintOnInkBg = Color(0x331FAA59);

  /// Soft pink used for unfilled streak segments and error-tinted borders.
  static const Color primarySoft = Color(0xFFF6D5CC);
  static const Color primaryBorder = Color(0xFFF2C8BF);

  /// Soft red glow under primary CTAs (26% primary).
  static const Color primaryShadow = Color(0x42EC3013);

  /// Bottom sheet / modal scrim (40% black).
  static const Color overlayScrim = Color(0x66000000);
}
