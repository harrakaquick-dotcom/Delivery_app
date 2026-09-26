import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// Outlined white button for secondary actions.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.height = 48,
    this.radius = 16,
    this.centered = false,
    this.foreground = AppColors.textPrimary,
    this.borderColor = AppColors.borderStrong,
  });

  final String label;
  final VoidCallback? onPressed;
  final double height;
  final double radius;
  final bool centered;
  final Color foreground;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final shape = BorderRadius.circular(radius);
    return Material(
      color: AppColors.card,
      shape: RoundedRectangleBorder(
        borderRadius: shape,
        side: BorderSide(color: borderColor),
      ),
      child: InkWell(
        onTap: onPressed ?? () {},
        borderRadius: shape,
        child: Container(
          height: height,
          width: double.infinity,
          alignment: centered ? Alignment.center : Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            label,
            style: AppTextStyles.titleSmall.copyWith(
              color: foreground,
              letterSpacing: centered ? 0.6 : 0,
            ),
          ),
        ),
      ),
    );
  }
}
