import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';

/// Big-key 3x4 keypad (1-9, blank, 0, backspace) for gloves and cracked screens.
class NumericKeypad extends StatelessWidget {
  const NumericKeypad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;

  static const String _backspace = '⌫';
  static const List<String> _keys = [
    '1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', _backspace, //
  ];

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(AppSpacing.radiusSmall + 2);
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 2.1,
      children: [
        for (final k in _keys)
          if (k.isEmpty)
            const SizedBox.shrink()
          else
            Material(
              color: AppColors.surface,
              borderRadius: radius,
              child: InkWell(
                borderRadius: radius,
                splashColor: AppColors.primaryLight,
                highlightColor: AppColors.primaryLight,
                onTap: () => k == _backspace ? onBackspace() : onDigit(k),
                child: Center(
                  child: Text(
                    k,
                    style: AppTextStyles.headingLarge.copyWith(
                      fontSize: 20,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),
            ),
      ],
    );
  }
}
