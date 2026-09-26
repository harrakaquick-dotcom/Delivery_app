import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';

/// Full-width primary CTA with the soft red glow; inert when [onPressed] is null.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.background = AppColors.primary,
    this.foreground = Colors.white,
    this.height = 58,
    this.radius = AppSpacing.radiusMedium,
    this.glow = AppColors.primaryShadow,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color background;
  final Color foreground;
  final double height;
  final double radius;
  final Color glow;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final shape = BorderRadius.circular(radius);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: shape,
        boxShadow: enabled
            ? [BoxShadow(color: glow, blurRadius: 18, offset: const Offset(0, 6))]
            : null,
      ),
      child: Material(
        color: enabled ? background : AppColors.surfaceMuted,
        borderRadius: shape,
        child: InkWell(
          onTap: onPressed,
          borderRadius: shape,
          child: Container(
            width: double.infinity,
            height: height,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Text(
              label,
              style: AppTextStyles.button.copyWith(
                color: enabled ? foreground : AppColors.textTertiary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
