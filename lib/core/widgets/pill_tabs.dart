import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';

/// Segmented control: a muted pill track with a white selected segment.
class PillTabs extends StatelessWidget {
  const PillTabs({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.height = 46,
  });

  final List<String> options;
  final String selected;
  final ValueChanged<String> onChanged;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: const Color(0xFFF0EEED),
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: Row(
        children: [
          for (var i = 0; i < options.length; i++) ...[
            if (i > 0) const SizedBox(width: 6),
            Expanded(child: _segment(options[i])),
          ],
        ],
      ),
    );
  }

  Widget _segment(String label) {
    final on = label == selected;
    return GestureDetector(
      onTap: () => onChanged(label),
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: on ? AppColors.card : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          boxShadow: on
              ? const [
                  BoxShadow(
                    color: Color(0x1F1A1A1A),
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppTextStyles.title.copyWith(
            color: on ? AppColors.textPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
