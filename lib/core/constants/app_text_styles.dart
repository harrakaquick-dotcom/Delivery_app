import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Archivo type scale (400 body, 600 headings/labels/buttons).
class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'Archivo';

  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 44,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.02 * 44,
    color: AppColors.textPrimary,
  );
  static const TextStyle displayMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 27,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.02 * 27,
    color: AppColors.textPrimary,
  );
  static const TextStyle headingLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.02 * 22,
    color: AppColors.textPrimary,
  );
  static const TextStyle headingMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.02 * 16,
    color: AppColors.textPrimary,
  );
  static const TextStyle label = TextStyle(
    fontFamily: fontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1 * 11,
    color: AppColors.textSecondary,
  );
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );
  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );
}
