import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';

/// Tinted pill used for status, step and badge labels.
class PillChip extends StatelessWidget {
  const PillChip(
    this.label, {
    super.key,
    this.background = AppColors.primaryLight,
    this.foreground = AppColors.primaryDark,
    this.letterSpacing,
    this.padding = const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
  });

  final String label;
  final Color background;
  final Color foreground;
  final double? letterSpacing;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.chip.copyWith(
          color: foreground,
          letterSpacing: letterSpacing,
        ),
      ),
    );
  }
}
