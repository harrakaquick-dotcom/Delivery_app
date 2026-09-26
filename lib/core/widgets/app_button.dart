import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';

/// Full-width primary CTA with the soft red glow; inert when [onPressed] is null.
class AppButton extends StatelessWidget {
  const AppButton({super.key, required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        boxShadow: enabled
            ? const [
                BoxShadow(
                  color: AppColors.primaryShadow,
                  blurRadius: 18,
                  offset: Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Material(
        color: enabled ? AppColors.primary : AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          child: Container(
            width: double.infinity,
            height: 58,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Text(
              label,
              style: AppTextStyles.button.copyWith(
                color: enabled ? Colors.white : AppColors.textDisabled,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
